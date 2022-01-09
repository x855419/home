// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC20.sol";

abstract contract Storage is IERC20 {

    /// Item struct
    struct Item {
        uint256 item_id;
        address item_owner;
        uint256 item_price;
        string item_name;
        string item_description;
        string item_pictures_hash;
        uint256 item_category;
        uint256 item_location;
        uint256 item_sending_location;
        uint256 item_sending_method;
        uint256 item_arrival_time;
        bool item_accept_erc20;
        IERC20 item_currency;
        bool item_admits_devolution;
        bool item_visibility;
        bool item_private;
        uint256 item_watchers;
        bool item_initialized;
        bool item_cancelled;
        bool item_cancelled_by_admin;
    }

    struct ItemTransaction {
        uint256 item_transaction_id;
        bool started_purchase;
        bool accepted_purchase;
        bool marked_as_sent;
        bool marked_as_received;
        bool marked_as_received_by_seller;
        bool started_devolution;
        bool marked_devolution_as_sent;
        bool marked_devolution_as_received;
        bool marked_devolution_as_received_by_buyer;
        bool buyer_screw;
        bool seller_screw;
        address payable buyer;
        address payable seller;
        bool accept_erc20;
        IERC20 currency;
        uint256 quantity;
        uint256 deposit;
        bool completed;
    }

    /// List of items and states of the items
    mapping(uint256=>Item) internal items;
    /// Index id of the item
    uint256 internal items_id_index;

    mapping(uint256=>uint256) internal items_quantities;

    /// Transaction state of the nth item
    mapping(uint256=>mapping(uint256=>ItemTransaction)) internal items_transactions;
    mapping(uint256=>uint256) internal items_transactions_id_index;

    mapping(address=>uint256[]) internal seller_items;

    /// Buyer items. Buyer address has ID of item and each item has a quantity
    mapping(address=>uint256[]) internal buyer_items;

    /// Address with the ids of the items to watch
    mapping(address=>uint256[]) internal watch_items;

    mapping(uint256=>mapping(address=>bool)) internal items_white_list;
}
