class MatterDevice:
    def __init__(self, discriminator: int, pincode: int, node_id: int, alias: str = None) -> None:
        self._discriminator = discriminator
        self._pincode = pincode
        self._node_id = node_id
        self._alias = alias

    def print(self) -> None:
        print(f"DISCRIMINATOR: {self._discriminator}")
        print(f"PINCODE: {self._pincode}")
        print(f"NODE ID: {self._node_id}")
        print(f"ALIAS: {self._alias}")

    def __dict__(self):
        # "DISCRIMINATOR": int, "NODE_ID": int, "ALIAS": str, "PINCODE": int
        return(
            {
                "DISCRIMINATOR": self._discriminator,
                "NODE_ID": self._node_id,
                "ALIAS": self._alias,
                "PINCODE": self._pincode
            }
        )
        
    def __str__(self) -> str:
        return(
            f"{self._alias}: MatterDevice(discriminator={self._discriminator}, pincode={self._pincode}, node_id={self._node_id})"
        )