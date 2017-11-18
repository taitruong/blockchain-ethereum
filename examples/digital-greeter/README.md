# hello world / greeter example
source:
- setup account and private network: https://hackernoon.com/heres-how-i-built-a-private-blockchain-network-and-you-can-too-62ca7db556c0
- create, deploy, and run greeter contract: https://www.ethereum.org/greeter

## create private network with a genesis block chain

First create a genesis block in JSON format
```
touch CustomGenesis.json
vi CustomGenesis.json
# json content:
{
    "config": {
        "chainId": 987, 
        "homesteadBlock": 0,
        "eip155Block": 0,
        "eip158Block": 0
    },
    "difficulty": "0x400",
    "gasLimit": "0x8000000",
    "alloc": {}
}
}
```

Now initialize block chain for the network with a datadir for databases and keystore
```
geth --identity myPrivateNode init ./CustomGenesis.json --datadir ~/.ethereum
```

Last but not least create private/test network
```
geth --datadir ~/.ethereum --networkid 9876
```

## create account

First connect geth client to network
```
geth attach ~/.ethereum/geth.ipc

```

create new account
```
> personal.newAccount()
Passphrase: 
Repeat passphrase: 
"0x05d58ef0decc5e398cf139ca0222a200513c2235"
# check balance
> eth.getBalance("0x05d58ef0decc5e398cf139ca0222a200513c2235")
0
```

## write and compile contract
- create, deploy, and run greeter contract: https://www.ethereum.org/greeter
- online compiler: https://ethereum.github.io/browser-solidity/

Use online compiler and compile this source code:
```
contract mortal {
    /* Define variable owner of the type address */
    address owner;

    /* This function is executed at initialization and sets the owner of the contract */
    function mortal() { owner = msg.sender; }

    /* Function to recover the funds on the contract */
    function kill() { if (msg.sender == owner) selfdestruct(owner); }
}

contract greeter is mortal {
    /* Define variable greeting of the type string */
    string greeting;
    
    /* This runs when the contract is executed */
    function greeter(string _greeting) public {
        greeting = _greeting;
    }

    /* Main function */
    function greet() constant returns (string) {
        return greeting;
    }
}
```
Then get the compiled contract:
- click right on "Details"
- Copy the code in the box labeled Web3deploy
- save in file greeter.js (this will be uploaded into the test network using geth)
- edit the greeter.js:

```
# edit first line and enter "hello, world"
var _greeting = "Hello, World";
# rename the classes to greeterContract and greeter
var greeterContract = web3.eth.contract([{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"greet","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]);
var greeter = greeterContract.new(_greeting,{from: web3.eth.accounts[0],data:'0x6060604052341561000f57600080fd5b6040516103a93803806103a983398101604052808051820191905050336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508060019080519060200190610081929190610088565b505061012d565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106100c957805160ff19168380011785556100f7565b828001600101855582156100f7579182015b828111156100f65782518255916020019190600101906100db565b5b5090506101049190610108565b5090565b61012a91905b8082111561012657600081600090555060010161010e565b5090565b90565b61026d8061013c6000396000f30060606040526004361061004c576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806341c0e1b514610051578063cfae321714610066575b600080fd5b341561005c57600080fd5b6100646100f4565b005b341561007157600080fd5b610079610185565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156100b957808201518184015260208101905061009e565b50505050905090810190601f1680156100e65780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415610183576000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b565b61018d61022d565b60018054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156102235780601f106101f857610100808354040283529160200191610223565b820191906000526020600020905b81548152906001019060200180831161020657829003601f168201915b5050505050905090565b6020604051908101604052806000815250905600a165627a7a723058207e1c7a8254474d06d2248c403b50e0d4c83c5b489c3bc59b9eaabb78d551c05e0029',gas:'4700000'}, function (e, contract){
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
        console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
        console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");
      } else {
        console.log("Contract mined! Address: " + contract.address);
        console.log(contract);
      }
 })
```


## deploy and run compiled contract
```
# now unlock account, otherwise you can't deploy
personal.unlockAccount(web3.eth.accounts[0])
# for some reason you have to start mining
miner.start()
loadScript("greeter.js")
# run
greeter.greet()
```

## Mining
```
# start mining for getting ether, on other console you'll see your miner
> miner.start()
null
# check balance after some 15-30seconds...
> eth.getBalance("0x05d58ef0decc5e398cf139ca0222a200513c2235")
0
> eth.getBalance("0x05d58ef0decc5e398cf139ca0222a200513c2235")
310000000000000000000
# when you have some balance, stop mining
> miner.stop()

```


