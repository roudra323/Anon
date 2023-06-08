import { useState, useEffect } from "react";
import { Button } from "decentraland-ui";
import { useAccount } from "wagmi";

const Msg = ({ state }) => {
  const { contract } = state;
  const { address } = useAccount();
  const [msg, setMsg] = useState("");
  useEffect(() => {
    const fetchMsg = async () => {
      const msg = await contract.readMsg(
        "0xCb62E7568819fd5C67A4A44cC485388a2969E42C"
      );
      setMsg(msg);
    };
    fetchMsg();
  }, [contract, address]);
  const handleShowMsg = () => {
    alert(msg);
  };
  return (
    <div>
      <Button onClick={handleShowMsg}>Show Message</Button>
    </div>
  );
};

export default Msg;
