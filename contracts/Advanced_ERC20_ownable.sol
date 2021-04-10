pragma solidity >=0.4.22 <0.9.0;

contract ERC20Interface  is owned{
    //store all the balances of wallets which have the token
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
    uint256 public totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    mapping(address => uint256) public balanceOf;
    // this mapping will track which addresses have allowed
    // whom  to spend tokens on thier behalf
    // when public functions are created, automatically getter functions are created.
    mapping(address => mapping(address => uint256)) public allowance;

    //events
    event Transfer(address indexed _from, address indexed _to, uint256 tokens);
    event Approval(
        address indexed _tokenOwner,
        address indexed _spender,
        uint256 tokens
    );

    constructor(
        string tokenName,
        string tokenSymbol,
        uint256 initialSupply
    ) public {
        // decimals will add 18 zero's to our intial supply
        totalSupply = initialSupply * 10**uint256(decimals);

        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }

    // will allow us to transfer money from any account to  any other account
    function _transfer(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        // this means that we wont transfer any tokens to the account of zero;
        require(_to != 0x0);
        // sender has to have the funds in order to transfer
        require(balanceOf[_from] >= _value);
        // prevent overflow  - the amount to be receievd must be more
        //or equal  than  what is current avaiable.
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        // nice mapping
        // will allow us to transfer money from any account to  any other account
        // ensures that the caller has enough money to send from the address
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
        // use case company account, you want employess to use monney from corporate account.
        // the allowance is the corporate account
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        // setting the amount the spender and spend from the originators account
        // sets who is authorized and the amount they are authorized to spend.
        // when this function is called it will override the previous amount
        allowance[msg.sender][_spender] = _value;
        // emit broadcasts the event to notify an web application or api
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
}

contract owned {
    public address owner;

    constructor() {
        owner = msg.sender;
    }

    //this will be used to restrict access to certain functions
    modifier onlyOwner {
        require(msg.sender == owner);
    }

    // transfer ownership of the token to someone else. 
    function transferOwnership (address newOwner) onlyOwner {
        owner = newOwner;
    }


function mintToken (address _target, uint256 _mintedAmount) onlyOwner {
    // function that can mint tokens whenever the owner decides
    balanceOf[_target] += _mintedAmount;
    totalSupply += _mintedAmount;
    emit Transfer(0, owner, _mintedAmount);
    emit Transfer(owner, _target, _mintedAmount);
}

function burn(uint256 _value) onlyOwner returns (bool success) {
    require(balanceOf[msg.sender] >= _value);  
    balanceOf[msg.sender] -= _value;
    totalSupply -= _value;
    emit Burn(msg.sender, _value);
    return true
}


}