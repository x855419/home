// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ERC20.sol";
//import "./security/Pausable.sol";

contract Cshop is ERC20 {

    //uint256 private immutable _cap = 56_000_000_000e18;

    address private minter;

    event ChangedMinter(address indexed _oldMinter, address indexed _newMinter);

    modifier onlyMinter {
        require(_msgSender() == minter);
        _;
    }

    /**
     * @dev Sets the value of the `cap`. This value is immutable, it can only be
     * set once during construction.
     */
    constructor(address _minter, uint256 initial_supply) ERC20("CipherShop", "CSHOP") {
        require(minter != address(0));
        minter = _minter;
        _mint(msg.sender, initial_supply);
    }

    /**
     * @dev Returns the cap on the token's total supply.
    function cap() public view virtual returns (uint256) {
        return _cap;
    }
    */

    function mint(address account, uint256 amount) public onlyMinter {
        _mint(account, amount);
    }

    function changeMinter(address _address) public onlyMinter {
        require(address(0) != _address);
        emit ChangedMinter(minter, _address);
        minter = _address;
    }

    /**
     * @dev See {ERC20-_mint}.
    function _mint(address account, uint256 amount) internal virtual override {
        //require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }
    */

    /*
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
    */

}
