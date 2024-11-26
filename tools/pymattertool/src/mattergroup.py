import src.matterdevice as matterdevice

class MatterGroup:
    def __init__(self, group_id: int, keyset_id: int, group_name: str, keyset: str = None) -> None:
        self._group_id = group_id
        self._keyset_id = keyset_id
        self._group_name = group_name
        self._keyset = keyset
        self._devices = []
     
    def print(self) -> None:
        print(f"Group name: {self._group_name}")
        print(f"KeySet Id: {self._keyset_id}")
        print(f"Group Id: {self._group_id}")
        if self._keyset:
            print(f"Group keyset: {self._keyset}")

    def AddDevice(self, device: matterdevice.MatterDevice) -> None:
        pass
    
