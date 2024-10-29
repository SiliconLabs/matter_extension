import os
import sys
import pathlib
import re
from ruamel.yaml import YAML
import ruamel
from collections import OrderedDict

include_reg_type1 = re.compile('#include ("|<).*?("|>)')
include_reg_type2 = re.compile('#include (").*?(")')
include_reg_type3 = re.compile('#include (<).*?(>)')
ROOT = pathlib.Path(sys.argv[0]).parent.parent.parent.absolute()
COMPONENT_DIRECTORY = os.path.join(ROOT, 'slc','component')
COMPONENT_DIR = os.path.join(ROOT, 'slc','component')
SKIP_LIST = ['CHIP_PROJECT_CONFIG_INCLUDE', 'SYSTEM_PROJECT_CONFIG_INCLUDE', 'INET_PROJECT_CONFIG_INCLUDE', 'BLE_PROJECT_CONFIG_INCLUDE']
NON_EXISTENT_FILES = []
RESOLVED_FILES = []
efr32_headers = ['PigweedLogger.h','Rpc.h','LEDWidget.h','matter_config.h','OTAConfig.h','BaseApplication.h', 'init_efrPlatform.h', 'efr32_utils.h']
std_c_headers = ["assert", "array","new","ctype","stdbool.h", "errno", "float", "limits", "locale", "math", "setjmp", "signal", "stdarg", "stddef","stdint", "stdio", "stdlib", "string", "time", "stddef"]
std_cpp_headers = ["cassert", "cctype", "cerrno", "cfenv", "cfloat", "cinttypes", "ciso646", "climits", "clocale", "cmath", "csetjmp", "csignal", "cstdarg", "cstdbool", "cstddef", "cstdint", "cstdio", "cstdlib", "cstring", "ctgmath", "ctime", "cuchar", "cwchar", "cwctype", "vector", "algorithm"]
found = False
root_inc_list = ['src','src/include','slc/inc', 'src/lib/support/pw_log_chip/public_overrides', 'src/lib/support/pw_log_chip/public', 'src/platform/silabs/efr32']
matter_component = {}
headers_found = 0
include_dirs = ['slc/config']
header_map = [# maps all header files found to an include directory supplied by the component file
    {'src' : []},
    {'slc/inc' : ['sl_matter_config.h']}
] 
headers_not_mapped = []
header_macros = {
    'CHIP_PLATFORM_CONFIG_INCLUDE' :  ['src/platform/silabs/CHIPPlatformConfig.h'],
    'CONFIGURATIONMANAGERIMPL_HEADER': ['src/platform/silabs/ConfigurationManagerImpl.h'],
    'SYSTEM_PLATFORM_CONFIG_INCLUDE': ['src/platform/silabs/SystemPlatformConfig.h'],
    'INET_PLATFORM_CONFIG_INCLUDE':   ['src/platform/silabs/InetPlatformConfig.h'],
    'INET_TCP_END_POINT_IMPL_CONFIG_FILE': ['src/inet/TCPEndPointImplOpenThread.h', 'src/inet/TCPEndPointImplLwIP.h'],
    'INET_UDP_END_POINT_IMPL_CONFIG_FILE': ['src/inet/UDPEndPointImplLwIP.h', 'src/inet/UDPEndPointImplOpenThread.h'],
    'CHIP_SYSTEM_LAYER_IMPL_CONFIG_FILE': ['src/system/SystemLayerImplFreeRTOS.h'],
    'BLE_PLATFORM_CONFIG_INCLUDE':  ['src/platform/silabs/BlePlatformConfig.h'],
    'EXTERNAL_CONFIGURATIONMANAGERIMPL_HEADER': ['src/platform/silabs/ConfigurationManagerImpl.h'],
    'EXTERNAL_CONNECTIVITYMANAGERIMPL_HEADER': ['src/platform/silabs/ConnectivityManagerImpl.h'], 
    'CHIPDEVICEPLATFORMEVENT_HEADER': ['src/platform/silabs/CHIPDevicePlatformEvent.h'],
    'KEYVALUESTOREMANAGERIMPL_HEADER':['src/platform/silabs/KeyValueStoreManagerImpl.h'],
    'PLATFORMMANAGERIMPL_HEADER': ['src/platform/silabs/PlatformManagerImpl.h'],
    'THREADSTACKMANAGERIMPL_HEADER': ['src/platform/silabs/ThreadStackManagerImpl.h'],
    'CONFIGURATION_HEADER':  ['src/app/util/config.h'],
    'BLEMANAGERIMPL_HEADER': ['src/platform/silabs/BLEManagerImpl.h'],
    'CHIP_DEVICE_PLATFORM_CONFIG_INCLUDE':['src/platform/silabs/CHIPDevicePlatformConfig.h'],
    'CONNECTIVITYMANAGERIMPL_HEADER': ['src/platform/silabs/ConnectivityManagerImpl.h'],
}
def file_exist(header, header_abs_path, header_list, include_path):

    if os.path.exists(header_abs_path):
        idx = next((index for (index, d) in enumerate(header_map) if include_path in d), None)
        indx = next((index for (index, d) in enumerate(header_list) if include_path in d), None)
        if idx is not None:

            if header in header_map[idx][include_path]:
                return True
            else:
                header_map[idx][include_path].append(header) 
                header_list[indx][include_path].append(header) if indx is not None else header_list.append({str(include_path) : [header]})  
                return True         
        else:
            header_list.append({str(include_path) : [header]})
            header_map.append({str(include_path) : [header]})
            return True
    return False

# function that recurses directories and returns a list of all header files found 
def recurse_dir(file_or_dir, parent_dir='', phase=0):
    if os.path.islink(file_or_dir):
        return 
    file_or_dir = os.path.realpath(file_or_dir)
    if os.path.isdir(file_or_dir):
        subdirs = os.listdir(file_or_dir)
        for unit in subdirs:
            recurse_dir(str(os.path.join(file_or_dir, unit)), parent_dir, phase)       
    elif os.path.isfile(file_or_dir): 
        file_ = str(os.path.basename(file_or_dir))
        if (('thread.slcp' in file_ or '.slcc' in file_) or (phase == 3 and file_.split('.')[-1] in ['h','hpp','c', 'cpp'])):
            if phase == 1:
                find_include_dirs(file_or_dir)
            elif phase == 2:
                scrape_component(file_or_dir) 
            elif phase == 3:
                resolve_file(file_or_dir)   
        else:
            return
# find all header include directories 
def find_include_dirs(file):

    global include_dirs
    with open(os.path.join(file), 'r') as slc_file:

        matter_component = YAML().load(slc_file)
        if 'include' in matter_component.keys():
            incKey = 'include'
        elif 'component_root_path' in matter_component.keys():
            incKey = 'component_root_path'
        else:
            return
        for inc_dir in matter_component[incKey]:
            if inc_dir['path'] not in include_dirs and inc_dir['path'] != '.':
                include_dirs.append(inc_dir['path'])
            else:
                continue

# searches file for header dependencies 
def find_headers_in_file(file, header_file_list):

    # read lines in source file and scrape it for included header files
    global header_map
    if not os.path.exists(file):
        if file not in NON_EXISTENT_FILES:
            NON_EXISTENT_FILES.append(file)
        return
    src_file = open(file, 'r', errors="ignore")
    file_lines = src_file.readlines()

    print("\n File Name {}:\n".format(str(os.path.basename(file))))

    # pattern match for '#include' to search source file for included header files
    for line in file_lines:
 
        if(include_reg_type1.match(line) is not None or ('#include' in line and '*' not in line)):
            inc_line = include_reg_type1.match(line)                
            
            if inc_line is None:
                inc_line = line
                header_relpath = str(inc_line)[9:-1]
                header_name = str(os.path.basename(str(inc_line)[9:-1]))
                header_name = header_name.replace('"', "")             
            else:
                header_relpath = str(inc_line.group())[10:-1]
                # check if file is included without a relative path 
                if include_reg_type2.match(line) is not None and len(header_relpath.split('/')) < 2:
                    header_relPath = str(os.path.join(str(os.path.dirname(file.replace(str(ROOT), ''))).lstrip('/'), header_relpath))
                    if os.path.exists(os.path.join(ROOT, header_relPath)) and 'simplicity_sdk' not in header_relPath:

                        for dir in include_dirs:
                            if '..' not in str(os.path.relpath(header_relPath, dir)).split('/')[0]:
                                header_relpath = str(os.path.relpath(header_relPath, dir))
                                break

                header_name = str(os.path.basename(str(inc_line.group())[10:-1]))

            # skip if header is a standard c/cpp header
            if (header_name.split(".")[0] in (std_c_headers + std_cpp_headers + SKIP_LIST)) and not header_relpath == 'lwip/errno.h':

                print("\tskipping {}".format(header_name.split(".")[0]))              
            else:                
                print('\t' + header_name)
                if not (header_name.endswith('h') or header_name.endswith('hpp') or header_name.endswith('ipp')):
                    if (header_name not in header_macros.keys()) and not (' ' in header_name):
                        print("New MACRO found: " + header_name)

                elif header_map.__len__() == 0:
                    header_file_list.append(header_relpath)
                else:
                    for dict in header_map:
                        for inc_dir, header_list in dict.items():
                            if header_relpath in header_list:
                                continue 
                    header_file_list.append(header_relpath)
# attempts to locate header file
def resolve_header_file(header_map, header_file_list, header_list):
    headers_found = 0
    global matter_component
    global headers_not_mapped
    temp_list = []
    additional_relpaths = ['lib/core/', 'platform/silabs/efr32/rs911x/','lib/asn1/', 'app/MessageDef/', 'protocols/user_directed_commissioning/', 'protocols/bdx/','app/util/', 'access/examples/', 'setup_payload/', 'platform/silabs/','credentials/examples/', 'lib/support/']

    for header in header_file_list:


        # check if header exists in the list of supplied include dirs
        for include_path in include_dirs:
            
            found = False
            header_abs_path = str(os.path.join(ROOT, include_path, header)).replace("\\", "/")
            
            # check if header file exists and map it to the correct include dir
            found = file_exist(header, header_abs_path, header_list, include_path)
            if found:
                headers_found += 1
                break

        if not found:
            for rel in additional_relpaths:
                header_abs_path = str(os.path.join(ROOT, 'src/' + rel, header)).replace("\\", "/")
                if file_exist(rel + header, header_abs_path, header_list, 'src'):
                    found = True
                    headers_found += 1
                    break
            if header in headers_not_mapped:
                continue
            elif not found:
                headers_not_mapped.append(header)
    return headers_found

def resolve_file(file):
    
    if file in RESOLVED_FILES:
        return
    header_file_list = []
    find_headers_in_file(file, header_file_list)

    if  len(header_file_list) == 0:
        if file not in RESOLVED_FILES:
            RESOLVED_FILES.append(file)
        return
    else:
        header_list = []
        if resolve_header_file(header_map, header_file_list, header_list):
            for dict in header_list:
                for include_dir, file_list in dict.items():
                    for file_ in file_list:
                        resolve_file(str(os.path.join(ROOT,include_dir,file_)))                        
                        if str(os.path.join(ROOT,include_dir,file_)) not in RESOLVED_FILES:
                            RESOLVED_FILES.append(str(os.path.join(ROOT,include_dir,file_)))
        else:
            if file not in RESOLVED_FILES:
                RESOLVED_FILES.append(file)

def update(inc_dir, val, file):
    # loads yaml object and maintains configuration of file (indents, spacing, comments .. etc)
    matter_component, ind, bsi = ruamel.yaml.util.load_yaml_guess_indent(open(file))


    header_file = ''
    full_path = inc_dir + '/' + val

    for x in range(0,len(full_path.split('/')) - 1):
        val_ = val.split('/')[:-(x+1)]
        include_dir_val = ''
        for i in range(0, len(full_path.split('/')[:-(x+1)])):
            include_dir_val += full_path.split('/')[:-1][i] + "/"
        include_dir_val = include_dir_val.rstrip('/')
        idx = next((index for (index, d) in enumerate(matter_component['include']) if include_dir_val == d['path'].rstrip('/')), None)
        if idx is not None:
            for i in range(len(full_path.split('/')) - x - 1, len(full_path.split('/'))):
                header_file += full_path.split('/')[i] + '/'            
            header_file = header_file[:-1]
            break

    # check if include directory exists
    if idx is not None: 
        if 'file_list' in matter_component['include'][idx]:
            for h in matter_component['include'][idx]['file_list']:
                for k, v in h.items():
                    print(h)
                    if v == header_file:
                        return  
            matter_component['include'][idx]['file_list'].append({'path' : header_file})
        else:    
            matter_component['include'][idx]['file_list'] = [{'path' : header_file}]
    elif 'slc/inc' == inc_dir:
        matter_component['include'].append(({'path': inc_dir , 'file_list' : [{'path' : val}]}))
    else:
        return
    

    # dump update yaml object into new componet 
    with open(os.path.join(file), 'w') as slc_file:
        YAML().dump(matter_component, slc_file)
        slc_file.close()            
    
                    
        
def update_header_key(inc_dir,val, lib=""):

    try:
        if 'openthread' == lib:
            pass
    except IndexError:
        pass
    if lib is not None:
        match lib:
            case 'core' | 'crypto' | 'controller':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'libchip'+lib+'.slcc')))
            case 'support' | 'system' | 'ble' | 'inet' | 'messaging' | 'transport':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'lib'+lib+'layer.slcc')))
                if lib == 'inet':
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'lib'+lib+'layer_wifi.slcc')))
            case 'shell':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform', 'shell', 'matter_'+lib+'.slcc')))
            case 'nlassert':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform', 'shell', 'matter_'+lib+'.slcc')))
            case 'wifi':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-wifi', 'matter_efr32_ncp.slcc')))
            case 'common' | 'trace':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk',  'app_common.slcc')))
            case 'rs911x_ncp_extension':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-wifi', 'rs911x',  lib+'.slcc')))
            case 'deviceinfoprovider':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk',  'libmatterdeviceinfoproviderexample.slcc')))
            case 'devicelayer':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'lib'+lib+'.slcc')))
                if os.path.exists(str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'lib'+lib+'_wifi.slcc'))):
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'lib'+lib+'_wifi.slcc')))
            case 'qrcode':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'libqrcode_common.slcc')))
            case 'pigweed':
                if 'pw_preprocessor' == val.split("/")[0] or 'pw_polyfill' == val.split("/")[0] or 'pw_span' == val.split("/")[0]  or 'pw_tokenizer' in inc_dir:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'pw_tokenizer.slcc')))
                elif 'pw_containers' == val.split("/")[0]:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'intrusive_list.slcc')))
                elif 'gtest' == val.split("/")[0] or 'pw_unit_test' == val.split("/")[0] == val.split("/")[0]:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'pw_span_test.slcc')))
                elif 'lib' == val.split("/")[0] or 'pw_result' == val.split("/")[0] or 'pw_function' == val.split("/")[0] or 'stdcompat' in inc_dir or 'lib/fit' in inc_dir:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'pw_protobuf.slcc')))
                elif 'pw_log' in val.split("/")[0]:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'pw_log_tokenized.slcc')))
                elif 'pw_work_queue' == val.split("/")[0] or 'pw_sync' == val.split("/")[0] or 'pw_thread' == val.split("/")[0] or 'pw_string' == val.split("/")[0] or 'pw_assert' == val.split("/")[0]:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'pw_work_queue.slcc')))
                elif 'pw_hdlc' in val.split("/")[0] or 'pw_rpc' == val.split("/")[0] or 'pw_sys_io' == val.split("/")[0] or 'pw_toolchain' == val.split("/")[0]:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'pw_rpc.slcc')))
                else:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', val.split("/")[0] + '.slcc')))
            case 'dnssd' | 'address_resolve':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', lib+'.slcc')))
                if lib == 'dnssd' and os.path.exists(str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', lib+'_wifi.slcc'))):
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', lib+'_wifi.slcc')))
            case 'protocols':
                if 'secure_channel' == val.split("/")[1]:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'libsecurechannel.slcc')))
                elif 'bdx' == val.split("/")[1]:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'libbdx.slcc')))
                else:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'libchip'+lib+'.slcc')))
            case 'platform' | 'openthread' | 'nlio':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'efr32.slcc')))
                if 'thread' not in val.lower() and os.path.exists(str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk','efr32_wifi.slcc'))):
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'efr32_wifi.slcc')))
            case 'lwip':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-wifi', 'matter_lwip.slcc')))
            case 'matter_platform':
                if 'dic' in inc_dir.lower():
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-wifi', 'matter_dic.slcc')))
                elif 'rs911x' in str(os.path.join(inc_dir, val)):
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-wifi', 'rs911x', 'rs911x_ncp_extension.slcc')))
                elif 'SiWx917' in str(os.path.join(inc_dir, val)):
                    if val == 'wfx_rsi.h':
                        update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'siwx917_common.slcc')))
                    elif 'system_si917.h' in val:
                        update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform', 'siwx917_soc_custom_startup.slcc')))
                    else:
                        update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform', 'matter_platform_siwx917.slcc')))
                elif val in efr32_headers or (val in ['efr32/' + s for s in efr32_headers]):
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform', 'matter_platform_efr32.slcc'))) 
                elif 'ICDSubscriptionCallback.h' in val:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'efr32_icd_subscription_callback.slcc'))) 
                elif 'matter_shell.h' in val:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform','shell', 'matter_shell.slcc'))) 
                elif 'lcd.h' in val or 'demo-ui' in val:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform','display', 'matter_lcd.slcc'))) 
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform','display', 'matter_lcd_917SOC.slcc'))) 
                elif 'uart.h' in val:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform','uart', 'matter_uart.slcc')))
                elif 'MemMonitoring.h' in val:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform','memory-monitoring', 'matter_memory_monitoring.slcc'))) 
                elif 'SilabsDeviceDataProvider.h' == val:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'silabs_factory_data_provider.slcc')))
                elif 'spi_multiplex.h' == val.split('/')[-1] or 'wf200' in str(os.path.join(inc_dir, val)).lower():
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-wifi','wf200', 'wf200_ncp_extension.slcc')))
                elif 'creds' in val.lower():
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'efr32_attestation_credentials.slcc')))
                else:
                     update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'app_common.slcc')))
            case 'wf200':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-wifi', 'wf200', 'wf200_ncp_extension.slcc')))
            case 'nlunit-test':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'libnlunit_test.slcc')))
            case 'setup_payload':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'libsetuppayload.slcc')))
            case 'wiseconnect':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-wifi', 'rs911x','wiseconnect_sapi.slcc')))
            case 'clusters':
                if 'basic-information' in inc_dir:
                    cluster_file = 'basic'
                else:
                    cluster_file = ((inc_dir.split("/")[3]).replace("-server", "")).replace("-", "_")
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-clusters', 'matter_' + cluster_file + '.slcc')))
            case 'app':
                if 'data-model' == val.split("/")[1] or 'MessageDef' == val.split("/")[1]:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'libchipdatamodel.slcc')))
                elif 'server' == val.split("/")[1]:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'libchipappserver.slcc')))
                elif 'clusters' == val.split("/")[1]:
                    if 'ota-requestor' == val.split("/")[2]:
                        update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-clusters', 'matter_ota_requestor.slcc')))                    
                else:
                    update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', lib+'_common.slcc')))
            case 'tracing':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'tracing.slcc')))
            case 'matter':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'tracing.slcc')))
            case 'FirmwareBuildTime.h':
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-platform', 'config', 'matter_includes.slcc')))    
            case 'include':
                pass    
            case 'format':
                pass        
            case _:
                update(inc_dir, val,file=str(os.path.join(COMPONENT_DIRECTORY,'matter-core-sdk', 'lib'+lib+'.slcc')))
    else:
        pass 


# updates slcc file 
def scrape_component(file):

    global headers_found 
    headers_found = 0
    with open(str(file), 'r') as slc_file:

        global matter_component
        parent_dir = str(os.path.dirname(file))
        matter_component = YAML().load(slc_file)
        file_list = []

        if 'source' not in matter_component or 'include' not in matter_component:
            return
        # iterate over source files list in component 
        for src_file in matter_component['source']:

            src_file_relpath = str(src_file['path'])
            src_file_abspath = str(os.path.join(ROOT, src_file_relpath))

            # read lines in source file and scrape it for included header files
            resolve_file(src_file_abspath)

        for header in headers_not_mapped:
            print("\t" + header)

        slc_file.close()    
        if headers_found == 0:
            return

def update_components():

    for dict in header_map:
        for inc_root, headers_list in dict.items(): 
            if 'third_party/silabs/simplicity_sdk' in inc_root:
                # Not going to parse gecko sdk headers right ?
                # should already be handle by slc natively
                continue
            if 'third_party/jsoncpp' in inc_root:
                # Not going to parse gecko sdk headers right ?
                # should already be handle by slc natively
                continue

            if inc_root in root_inc_list:
                for header in headers_list:       
                    match header.split("/")[0]:
                        case 'lib':
                            update_header_key(inc_root, header, lib=header.split("/")[1])
                        case 'CHIPVersion.h':
                            update_header_key(inc_root, header, lib='support')
                        case 'pw_log_backend':
                            update_header_key(inc_root, header, lib='pigweed')
                        case 'pw_log_chip':
                            update_header_key(inc_root, header, lib='pigweed')
                        case 'platform':
                            if inc_root == 'src/include':
                                update_header_key(inc_root, header, lib='devicelayer')
                            elif 'wifi' in str(os.path.join(inc_root, header)):
                                update_header_key(inc_root, header, lib='wifi')
                            elif 'rs911x' in str(os.path.join(inc_root, header)):
                                update_header_key(inc_root, header, lib='rs911x_ncp_extension')
                            else:
                                update_header_key(inc_root, header,  lib=header.split("/")[0])
                        case _:
                            if inc_root == 'src/platform/silabs/efr32':
                                update_header_key(inc_root, header, lib='platform')
                            elif inc_root == 'slc/inc':
                                if 'brd' in header.split("/")[0]:
                                    update_header_key(inc_root, header,  lib='lwip')
                                elif 'sl_matter_config.h' in header:
                                    continue
                                else:
                                    update_header_key(inc_root, header,  lib=header.split("/")[0])
                            else:
                                if 'sl_matter_config.h' in header:
                                    continue
                                update_header_key(inc_root, header,  lib=header.split("/")[0])
            elif 'examples/platform/silabs' in inc_root:
                for header in headers_list:
                    update_header_key(inc_root, header, lib='matter_platform') 
            elif 'src/app/clusters' in inc_root:
                for header in headers_list:
                    update_header_key(inc_root, header, lib='clusters')
            elif 'nlio' in inc_root:
                for header in headers_list:
                    update_header_key(inc_root, header, lib='nlio')
            elif inc_root == 'examples/providers':
                for header in headers_list:
                    update_header_key(inc_root, header, lib='deviceinfoprovider') 
            elif inc_root == 'src/platform/silabs/efr32/wifi':
                for header in headers_list:
                    update_header_key(inc_root, header, lib='wifi')                
            elif 'src/lib' in inc_root:
                for header in headers_list:
                    update_header_key(inc_root, header,  lib=header.split('/')[0])  
            elif 'rs911x' in inc_root:
                for header in headers_list:
                    update_header_key(inc_root, header,  lib='rs911x_ncp_extension')                                                    
            elif ('examples/platform' in inc_root and not 'rs911x' in inc_root) or 'zzz_generated/app-common' == inc_root or 'third_party/nlassert' in inc_root:
                for header in headers_list:
                    update_header_key(inc_root, header,  lib='common')
            elif 'lwip' in inc_root:
                if len(inc_root.split("/")) > 1:    
                    for header in headers_list:
                        print(inc_root)             
                        update_header_key(inc_root, header,  lib=inc_root.split("/")[1]) 
                else:
                    for header in headers_list:             
                        update_header_key(inc_root, header,  lib=inc_root) 
            elif 'nlunit-test' in inc_root:
                for header in headers_list:             
                    update_header_key(inc_root, header,  lib=inc_root.split("/")[1]) 
            elif 'pigweed' == inc_root:
                for header in headers_list:             
                    update_header_key(inc_root, header,  lib=inc_root.split("/")[1])  
            elif 'QRCode' in inc_root:
                for header in headers_list:             
                    update_header_key(inc_root, header,  lib='qrcode') 
            elif 'wiseconnect' in inc_root:
                for header in headers_list:             
                    update_header_key(inc_root, header,  lib='wiseconnect') 
            elif 'examples/shell' in inc_root or 'src/lib/shell' in inc_root:
                for header in headers_list:             
                    update_header_key(inc_root, header,  lib='shell') 
            elif 'simplicity_sdk' in inc_root:
                if 'wfx_fmac_driver' in inc_root:
                    for header in headers_list:
                        update_header_key(inc_root, header,  lib='wf200') 
                continue                 
            else:
                if inc_root == 'examples/lighting-app/silabs/efr32/include':
                    continue
                print("inc root missing: " + inc_root)
                
def main(params):

    zap_generated_dir = None
    if params != None:
        if os.path.isdir(params):

            if os.path.isabs(params):
                zap_generated_dir = params
            else:
                zap_generated_dir = str(os.path.join(ROOT, params))

    for step in range(3):
        if step < 2:
            for file in os.listdir(COMPONENT_DIR):
                recurse_dir(str(os.path.join(COMPONENT_DIR,file)), parent_dir=file, phase=step+1)

        if zap_generated_dir is not None and step == 2:
            recurse_dir(zap_generated_dir, parent_dir=file, phase=step+1)



    for k, v in header_macros.items():
        for file in v:
            header_map[0]['src'].append(file[4:])
            resolve_file(str(os.path.join(ROOT, file)))

    update_components()

    print(NON_EXISTENT_FILES)   

if __name__ == '__main__':
    if len(sys.argv) > 1:
        main(sys.argv[1])
    else:
        main(params=None)
