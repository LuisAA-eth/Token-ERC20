// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;
interface IERC20 
{
    function totalSupply() external view returns (uint256);

    function balanceOf (address account) external view returns (uint256);

    function transfer (address to, uint256 _numTokens) external returns (bool);

    function allowance (address owner, address spender) external view returns (uint256); 

    function approve (address spender, uint256 _numTokens) external returns (bool);

    function transferFrom (address from, address to, uint256 _numTokens) external returns (bool); 

    event Transfer (address indexed from, address indexed to, uint256 amount);
    event Approval (address indexed from, address indexed to, uint256 amount); 
}

contract ERC20 is IERC20 {

    //VARIABLES

    mapping (address=>uint256) private _balances; 

    mapping (address => mapping(address=>uint256)) private _allowances; 
    
    uint256 private _totalSupply; 
    string private _name; 
    string private _symbol; 

    constructor (string memory name_, string memory symbol_)
    {
        _name = name_;
        _symbol= symbol_;
    }

    function name() public view  virtual returns (string memory){
        return _name; 
    }

    function symbol() public view  virtual returns (string memory){
        return _symbol; 
    }

    function decimals() public view virtual returns (uint8)
    {
        return 18; 
    }

    function totalSupply() public view virtual override returns (uint256)
    {
        return _totalSupply;
    }

    function balanceOf (address account) public view virtual override returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address to, uint256 _numTokens) public virtual override returns (bool)
    {
        address owner = msg.sender;
        _transfer(owner, to, _numTokens);
        return true;
    }

    function allowance (address owner, address spender) public view virtual override returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve (address spender, uint256 _numTokens) public virtual override returns (bool)
    {
        address owner = msg.sender;
        _approve (owner, spender, _numTokens);
        return true;
    }

    function transferFrom (address from, address to, uint256 _numTokens) public virtual override returns(bool)
    {
        address spender = msg.sender; 
        _spendAllowance (from, spender, _numTokens);
        _transfer(from, to, _numTokens);

        return true;
    }

    function increaseAllowance (address spender, uint256 addedValue) public virtual returns (bool)
    {
        address owner = msg.sender;
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance (address spender, uint256 subtractedValue) public virtual returns (bool)
    {
        address owner = msg.sender; 
        uint256 currentAllowance = allowance(owner, spender);

        require (currentAllowance >= subtractedValue, "ER20: decreased allowance below zero");

        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }


    //FUNCIONES INTERNAS

    function _transfer(address from, address to, uint256 _numTokens) internal virtual {
        require(from!= address(0), "ERC20: transfer from the zero address"); 
        require(to!= address(0), "ERC20: transfer to the zero address"); 

        _beforeTokenTransfer(from, to, _numTokens);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= _numTokens, "ERC20: transfer amount exceeds balance");

        unchecked {
            _balances[from]= fromBalance - _numTokens;
        }

        _balances[to]+= _numTokens;
        emit Transfer(from, to, _numTokens);

        _afterTokenTransfer(from, to, _numTokens);
    }

    function _approve(address owner, address spender, uint256 _numTokens) internal virtual 
    {
        require(owner!= address(0), "ERC20: transfer from the zero address"); 
        require(spender!= address(0), "ERC20: transfer to the zero address"); 

        _allowances[owner][spender] = _numTokens;

        emit Approval (owner, spender, _numTokens); 
    }

    function _spendAllowance (address owner, address spender, uint256 _numTokens) internal virtual
    {
        uint256 currentAllowance = allowance (owner, spender);

        if(currentAllowance != type(uint256).max)
        {
            require(currentAllowance >= _numTokens,"ERC20: insufficient balance" );
            unchecked {
                _approve(owner, spender, currentAllowance - _numTokens); 
            }
        }
    }

    function _mint (address account, uint256 _numTokens) internal virtual {
        require (account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, _numTokens);
        _totalSupply += _numTokens;
        unchecked {
            _balances[account]+= _numTokens;
        }

        emit Transfer(address(0), account, _numTokens);

        _afterTokenTransfer(address(0), account, _numTokens);
    }

    function _burn (address account, uint256 _numTokens) internal virtual {
        require (account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(address(0), account, _numTokens);
        
        uint256 accountBalance = _balances[account];
        require (accountBalance >= _numTokens, "ERC20: burn amount exceeds balance");

        unchecked {
            _balances[account]= accountBalance - _numTokens;
            _totalSupply -= _numTokens;
        }

        emit Transfer (account, address(0), _numTokens); 
         _afterTokenTransfer(address(0), account, _numTokens);
    }

    function _beforeTokenTransfer (address from, address to, uint256 _numTokens) internal virtual {}
    function _afterTokenTransfer (address from, address to, uint256 _numTokens) internal virtual {}



}