// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AccessControl {

    /// owner address
    address public owner = msg.sender;
    
    /// map of admins
    mapping(address=>bool) public admins;

    modifier onlyOwner() {
        require(msg.sender == owner, "This function is restricted to the contract's owner");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender] == true, "This function is restricted to allowed admins");
        _;
    }

    function changeOwner(address _address) external onlyOwner {
        require(_address != address(0));
        owner = _address;
    }

    function isAdmin(address _address) internal view returns (bool) {
        bool value = false;
        if (admins[_address]) {
            value = true;
        }
        return value;
    }

    function addAdmin(address _address) external onlyOwner {
        require(isAdmin(_address) == false, "Address already registered as admin");
        admins[_address] = true;
    }

    function deleteAdmin(address _address) external onlyOwner {
        require(isAdmin(_address), "Adress isn't registered as admin");
        admins[_address] = false;
    }

    function revokeAdmin() external onlyAdmin {
        admins[msg.sender] = false;
    }
}
