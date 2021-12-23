// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CipherShop {

    address public owner = msg.sender;

    struct Item {
        uint256 item_id;
        address item_owner;
        bool started_purchase;
        bool accepted_purchase;
        bool item_visibility;
        uint32 item_watchers;
        bool buyer_scrow;
        bool seller_scrow;
    }

    Item[] items;
    uint256 items_id_index;
    mapping(address=>Item[]) seller_items;

    mapping(address=>Item[]) watch_items;

    mapping(address=>uint256) transactions_deposit;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "This function is restricted to the contract's owner"
        );
        _;
    }

    function addItem(address _item_owner) public {
        Item memory item = Item(items_id_index, _item_owner, false, false, false, 0, false, false);
        items_id_index++;
        items.push(item);
        seller_items[_item_owner].push(item);
    }

    function startPurchase(uint256 _item_id) external payable {
        require(msg.value > 0);
    }

}
