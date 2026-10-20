# Matter Wake on Matter Example

An example showing Matter running alongside the OT-NCP and BLE-RCP stack.

<hr>

-   [Matter Wake on Matter Example](#matter-wake-on-matter-example)
    -   [Introduction](#introduction)
    -   [Building](#building)
    -   [Flashing the Application](#flashing-the-application)
    -   [Viewing Logging Output](#viewing-logging-output)

<hr>

## Introduction

The Wake on Matter example provides a baseline demonstration of an OT-NCP
combined with a Matter node that receives subscriptions to wake up the host. It also exposes the BLE-RCP stack through the CPC interface.

## Building

This application is solely supported with the SLC toolchain. Please install it through [SLT](https://www.silabs.com/software-and-tools/simplicity-studio/silicon-labs-tool?tab=overview) or build the application with [Simplicity Studio](https://www.silabs.com/software-and-tools/simplicity-studio?tab=overview).

## Viewing Logging Output

With this application, logs are solely available through the [Segger RTT interface](https://www.segger.com/products/debug-probes/j-link/tools/rtt-viewer/).


## Wake on Matter configuration

This sample app allows subscriptions to another Matter device through a NCP attached to a raspberry pi. 
Steps

1. Commission this application to a Matter Thread network
2. Grant ACL to the desired node with which you want to establish a subscription
   with the following command

```
    chip-tool accesscontrol write acl '[{"fabricIndex": 1, "privilege": 1, "authMode": 2, "subjects": [<woM node ID>], "targets": null}]' <target node id> 0
```

Important detail:
`write acl` replaces the full ACL list; it does not append an entry. So if you already have other ACL entries, you must include them too in the same JSON array, for example:

```
chip-tool accesscontrol write acl '[{"fabricIndex": 1, "privilege": 5, "authMode": 2, "subjects": [112233], "targets": null}, {"fabricIndex": 1, "privilege": 1, "authMode": 2, "subjects": [<node ID>], "targets": null}]' 1 0
```

3. Run this command on the pi so that a subscription can be established between the node and the WoM device
```
    > host_app establish_subscription <fabricIndex> <nodeId> <endpointId> <clusterId>
```     

## Prerequisites

Host packages (Ubuntu):

```sh
sudo apt-get install net-tools     # provides ifconfig, required by verify_install.sh
```

Silabs services running on the host:

- `cpcd.service` ([CPC daemon](https://docs.silabs.com/multiprotocol/latest/multiprotocol-solution-linux/building-cpcd-locally) bridging the NCP) 
- `otbr-agent.service` ([OpenThread Border Router agent](https://docs.silabs.com/multiprotocol/latest/multiprotocol-solution-linux/building-otbr-locally))
- Bluetooth [HCI bridge](https://docs.silabs.com/multiprotocol/latest/multiprotocol-solution-linux/building-bluetooth-host-locally) (optional)
- A committed active OT dataset (`sudo ot-ctl dataset init new` then
  `sudo ot-ctl dataset commit active` if none is present)

Matter tools:

- `chip-tool` on `PATH` (built from the connectedhomeip tree).
- `mmic_host` on `PATH` (build instructions below).
- A wake-on-matter device flashed and connected via the running `cpcd`
  instance.
- A second Matter accessory (e.g. the `lighting-app`) in commissioning mode
  (BLE advertising), reachable with the standard test setup pin `20202021`
  and discriminator `3840`.

## Testing / End-to-end validation

The `scripts/` directory ships with two helpers that together validate an
entire wake-on-matter setup end-to-end from an Ubuntu-based OpenThread Border
Router (OTBR) host:

- `scripts/verify_install.sh` - checks that `cpcd.service`,
  `otbr-agent.service` and the `wpan0` interface are present and up. If
  `wpan0` is missing but an active OT dataset exists, it attempts to bring it
  up via `ot-ctl`.
- `scripts/tests/end_to_end_validation.sh` - runs the checks above, then
  commissions an accessory + the wake-on-matter NCP, writes the ACL, and
  establishes a subscription.

## Building `mmic_host`

`mmic_host` is the host-side CLI used to drive the NCP (commission, query
state, establish subscriptions, etc.). Its sources live at
`third_party/matter_sdk/examples/platform/silabs/mmic/`.

CPC transport (recommended when `cpcd` is already bridging the device):

```sh
cd third_party/matter_sdk/examples/platform/silabs/mmic
cmake -S . -B build -DMMIC_USE_CPC=ON
cmake --build build
```

The resulting binary is `build/mmic_host`. Add it to `PATH` (or point the
test script at it with `MMIC_HOST=/full/path/to/mmic_host`).

For the full mmic build options (compiler selection, non-standard libcpc
locations, one-shot vs interactive mode), see
`third_party/matter_sdk/examples/platform/silabs/mmic/README.md`.

## End-to-end test steps

Once the prerequisites are in place, run:

```sh
./scripts/tests/end_to_end_validation.sh
```

The script performs, in order:

1. **`verify_install.sh`** - verifies `cpcd.service`, `otbr-agent.service`,
   and that `wpan0` is up (auto-brings it up via `ot-ctl` if a dataset is
   present but the interface is down).
2. **Commission the accessory over BLE-Thread** - reads the active dataset
   with `sudo ot-ctl dataset active -x` and runs:
   ```sh
   chip-tool pairing ble-thread <ACCESSORY_NODE_ID> hex:<dataset> \
       <SETUP_PINCODE> <DISCRIMINATOR>
   ```
3. **Commission the wake-on-matter NCP** - runs `mmic_host matter_state` as a
   pre-check; if a fabric is already present it issues `mmic_host decommission`
   and confirms the fabric count returns to 0. Then:
   ```sh
   mmic_host commission <NCP_NODE_ID>
   mmic_host matter_state          # must show the new nodeId
   ```
4. **Grant ACL** - allows the NCP to open a CASE session against the accessory:
   ```sh
   chip-tool accesscontrol write acl \
       '[{"fabricIndex": 1, "privilege": 1, "authMode": 2, "subjects": [<NCP_NODE_ID>], "targets": null}]' \
       <ACCESSORY_NODE_ID> 0
   ```
5. **Establish a subscription** from the NCP toward the accessory:
   ```sh
   mmic_host establish_subscription \
       <SUB_FABRIC_INDEX> <ACCESSORY_NODE_ID> \
       <SUB_ENDPOINT_ID> <SUB_CLUSTER_ID> <SUB_ATTRIBUTE_ID>
   ```

Every step prints `[PASS]` or `[FAIL]`. The first failing step aborts the
script (exit code `1`), and a final summary block is printed.
`Ctrl+C` interrupts and exits with `130`.

## Configuration

All values are overridable via environment variables (defaults shown):

| Variable             | Default                | Purpose                                    |
| -------------------- | ---------------------- | ------------------------------------------ |
| `CHIP_TOOL`          | `chip-tool`            | chip-tool binary                           |
| `MMIC_HOST`          | `mmic_host`            | mmic_host binary                           |
| `VERIFY_SCRIPT`      | `<script_dir>/verify_install.sh` | Path to `verify_install.sh`      |
| `ACCESSORY_NODE_ID`  | `1`                    | Node id assigned to the Matter accessory   |
| `NCP_NODE_ID`        | `100`                  | Node id assigned to the wake-on-matter NCP |
| `SETUP_PINCODE`      | `20202021`             | Accessory setup pin code                   |
| `DISCRIMINATOR`      | `3840`                 | Accessory setup discriminator              |
| `SUB_FABRIC_INDEX`   | `1`                    | Fabric index used for the subscription     |
| `SUB_ENDPOINT_ID`    | `0`                    | Subscription endpoint                      |
| `SUB_CLUSTER_ID`     | `0x0028`               | Basic Information cluster                  |
| `SUB_ATTRIBUTE_ID`   | `0x0000`               | DataModelRevision attribute                |
| `COMMISSION_TIMEOUT` | `180`                  | BLE-Thread commission timeout (s)          |
| `CHIP_TOOL_TIMEOUT`  | `60`                   | chip-tool ACL write timeout (s)            |
| `MMIC_TIMEOUT`       | `30`                   | mmic_host command timeout (s)              |

Example - commission the NCP with node id `200` and target a `lighting-app`
accessory with node id `42` on cluster `OnOff` (`0x0006`) / attribute `OnOff`
(`0x0000`) on endpoint `1`:

```sh
NCP_NODE_ID=200 \
ACCESSORY_NODE_ID=42 \
SUB_CLUSTER_ID=0x0006 \
SUB_ATTRIBUTE_ID=0x0000 \
SUB_ENDPOINT_ID=1 \
./scripts/tests/end_to_end_validation.sh
```

## Troubleshooting

- **`verify_install.sh` reports `ifconfig not installed`** - install
  `net-tools` (`sudo apt-get install net-tools`).
- **`wpan0` never appears** - no active dataset. Create one:
  `sudo ot-ctl dataset init new && sudo ot-ctl dataset commit active`.
- **`chip-tool pairing ble-thread` hangs** - the accessory is not advertising
  or BlueZ is not reachable. Confirm the device is in commissioning mode and
  that `sudo systemctl status bluetooth` is active.
- **`mmic_host matter_state` fabric nodeId mismatch** - a stale fabric is
  present. The script auto-runs `mmic_host decommission` in that case; if the
  check still fails, decommission manually and re-run.
- **Subscription fails at Sigma1 with a `destinationId` mismatch** - the
  accessory and NCP are on different fabrics, or the NCP holds a stale IPK.
  Factory-reset the NCP, decommission the accessory
  (`chip-tool pairing unpair <node-id>`) and re-run the script from step 2.
