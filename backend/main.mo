import Bool "mo:base/Bool";
import Func "mo:base/Func";

import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

actor {
  // Define the structure for a shopping list item
  type ShoppingItem = {
    id: Nat;
    text: Text;
    completed: Bool;
  };

  // Stable variable to store the shopping list items
  stable var items : [ShoppingItem] = [];
  stable var nextId : Nat = 0;

  // Function to add a new item to the shopping list
  public func addItem(text: Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem : ShoppingItem = {
      id = id;
      text = text;
      completed = false;
    };
    items := Array.append(items, [newItem]);
    id
  };

  // Function to mark an item as completed or uncompleted
  public func toggleItem(id: Nat) : async Bool {
    let index = Array.indexOf<ShoppingItem>({ id = id; text = ""; completed = false }, items, func(a, b) { a.id == b.id });
    switch (index) {
      case null { false };
      case (?i) {
        let item = items[i];
        let updatedItem = {
          id = item.id;
          text = item.text;
          completed = not item.completed;
        };
        items := Array.tabulate(items.size(), func (j: Nat) : ShoppingItem {
          if (j == i) { updatedItem } else { items[j] }
        });
        true
      };
    }
  };

  // Function to delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    let newItems = Array.filter<ShoppingItem>(items, func(item) { item.id != id });
    if (newItems.size() < items.size()) {
      items := newItems;
      true
    } else {
      false
    }
  };

  // Query function to get all items
  public query func getItems() : async [ShoppingItem] {
    items
  };
}
