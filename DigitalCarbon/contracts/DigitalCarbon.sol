// SPDX-License-Identifier: MIT
/*

________  .__       .__  __         .__    _________             ___.                  
\______ \ |__| ____ |__|/  |______  |  |   \_   ___ \_____ ______\_ |__   ____   ____  
 |    |  \|  |/ ___\|  \   __\__  \ |  |   /    \  \/\__  \\_  __ \ __ \ /  _ \ /    \ 
 |    `   \  / /_/  >  ||  |  / __ \|  |__ \     \____/ __ \|  | \/ \_\ (  <_> )   |  \
/_______  /__\___  /|__||__| (____  /____/  \______  (____  /__|  |___  /\____/|___|  /
        \/  /_____/               \/               \/     \/          \/            \/ 

*/

pragma solidity ^0.8.19;

/**
  DIGITALCARBON (cNEEV) Token
  Fixed Supply: 2,000,000,000
  Features: ERC-20, EIP-2612 Permit, ERC-1363, Burnable, No Admin
  Powered By: "A Cognitive Practical Grid Of Reality"
  Developer: https://metareality.tech 
  Gamification: https://matrix.gravitons.ai
  Getting Started: https://gravitons.ai


                __                              .__  .__  __          
  _____   _____/  |______ _______   ____ _____  |  | |__|/  |_ ___.__.
 /     \_/ __ \   __\__  \\_  __ \_/ __ \\__  \ |  | |  \   __<   |  |
|  Y Y  \  ___/|  |  / __ \|  | \/\  ___/ / __ \|  |_|  ||  |  \___  |
|__|_|  /\___  >__| (____  /__|    \___  >____  /____/__||__|  / ____|
      \/     \/          \/            \/     \/               \/     

*/

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Permit {
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v, bytes32 r, bytes32 s
    ) external;

    function nonces(address owner) external view returns (uint256);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

interface IERC1363 is IERC20 {
    function transferAndCall(address to, uint256 value) external returns (bool);
    function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
    function approveAndCall(address spender, uint256 value) external returns (bool);
    function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
}

interface IERC1363Receiver {
    function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4);
}

interface IERC1363Spender {
    function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
}

contract DigitalCarbon is IERC20, IERC20Permit, IERC1363 {
    string public constant name = "DigitalCarbon";
    string public constant symbol = "cNEEV";
    uint8 public constant decimals = 18;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    bytes32 public immutable DOMAIN_SEPARATOR;
    bytes32 public constant PERMIT_TYPEHASH =
        0xd505accf25c6cd1f45e27f72e6b3adf95d8d52f1f020c0b90d980abf918f0f55;
    mapping(address => uint256) public nonces;


    constructor() {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }

        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(name)),
                keccak256(bytes("1")),
                chainId,
                address(this)
            )
        );

        uint256 supply = 2000000000 * 10 ** decimals;
        balanceOf[msg.sender] = supply;
        totalSupply = supply;
        emit Transfer(address(0), msg.sender, supply);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= amount, "ERC20: insufficient allowance");

        if (allowed != type(uint256).max) {
            allowance[from][msg.sender] = allowed - amount;
        }

        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        _approve(msg.sender, spender, allowance[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
        uint256 current = allowance[msg.sender][spender];
        require(current >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(msg.sender, spender, current - subtractedValue);
        return true;
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) external {
        uint256 allowed = allowance[account][msg.sender];
        require(allowed >= amount, "ERC20: burn exceeds allowance");

        if (allowed != type(uint256).max) {
            allowance[account][msg.sender] = allowed - amount;
        }

        _burn(account, amount);
    }

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v, bytes32 r, bytes32 s
    ) external {
        require(block.timestamp <= deadline, "Permit: expired");

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline)
                )
            )
        );

        address recovered = ecrecover(digest, v, r, s);
        require(recovered != address(0) && recovered == owner, "Permit: invalid signature");

        _approve(owner, spender, value);
    }

    function transferAndCall(address to, uint256 value) public returns (bool) {
        return transferAndCall(to, value, "");
    }

    function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool) {
        _transfer(msg.sender, to, value);
        require(IERC1363Receiver(to).onTransferReceived(msg.sender, msg.sender, value, data) ==
                IERC1363Receiver.onTransferReceived.selector, "1363: callback failed");
        return true;
    }

    function approveAndCall(address spender, uint256 value) public returns (bool) {
        return approveAndCall(spender, value, "");
    }

    function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool) {
        _approve(msg.sender, spender, value);
        require(IERC1363Spender(spender).onApprovalReceived(msg.sender, value, data) ==
                IERC1363Spender.onApprovalReceived.selector, "1363: callback failed");
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: from zero");
        require(to != address(0), "ERC20: to zero");

        uint256 fromBal = balanceOf[from];
        require(fromBal >= amount, "ERC20: insufficient balance");

        unchecked {
            balanceOf[from] = fromBal - amount;
        }
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from zero");
        require(spender != address(0), "ERC20: approve to zero");

        allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from zero");

        uint256 bal = balanceOf[account];
        require(bal >= amount, "ERC20: burn exceeds balance");

        unchecked {
            balanceOf[account] = bal - amount;
            totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);
    }
}
