import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Option "mo:base/Option";

actor {
    type Item = {
        id: Nat;
        name: Text;
        quantity: Nat;
        category: Text;
    };

    private var nextId: Nat = 0;
    private var items = HashMap.HashMap<Nat, Item>(0, Nat.equal, Hash.hash);

    public func addItem(name: Text, quantity: Nat, category: ?Text) : async Nat {
        let id = nextId;
        let newItem: Item = {
            id;
            name;
            quantity;
            category = Option.get(category, "General");
        };
        items.put(id, newItem);
        nextId += 1;
        id
    };

    public func updateItem(id: Nat, name: ?Text, quantity: ?Nat, category: ?Text) : async Bool {
        switch (items.get(id)) {
            case (null) { false };
            case (?existingItem) {
                let updatedItem: Item = {
                    id = existingItem.id;
                    name = Option.get(name, existingItem.name);
                    quantity = Option.get(quantity, existingItem.quantity);
                    category = Option.get(category, existingItem.category);
                };
                items.put(id, updatedItem);
                true
            };
        }
    };

    public query func getItem(id: Nat) : async ?Item {
        items.get(id)
    };

    public query func getAllItems() : async [Item] {
        Iter.toArray(items.vals())
    };

    public query func getItemsByCategory(category: Text) : async [Item] {
        Array.filter<Item>(Iter.toArray(items.vals()), func(item: Item) : Bool {
            item.category == category
        })
    };

    public func deleteItem(id: Nat) : async Bool {
        switch (items.remove(id)) {
            case (null) { false };
            case (?_) { true };
        }
    };
}
