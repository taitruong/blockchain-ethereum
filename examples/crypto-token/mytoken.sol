/*
* Source: https://www.ethereum.org/token
*/
contract MyToken {

    string public name;
    string public symbol;
    uint8 public decimals;
    /*
    * This creates an array with all balances
    */
    mapping(address => uint256) public balanceOf;

    /*
    * Initial contructor, occurs only once on upload
    */
    function MyToken(uint256 initialBalance, string tokenName, string tokenSymbol, uint8 decimalUnits) {
        balanceOf[msg.sender] = initialBalance;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
    }

    function transfer(address _to, uint256 _value) {
        /* Check if sender has balance and for overflows */
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        /* Add and subtract balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    /* Empty function events for clients like Ethereum Wallet keeping track of activities happening in the contract */
    event Transfer(address indexed from, address indexed to, uint256 value);
}