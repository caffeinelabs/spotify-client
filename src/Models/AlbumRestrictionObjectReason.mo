/// The reason for the restriction. Albums may be restricted if the content is not available in a given market, to the user's subscription type, or when the user's account is set to not play explicit content. Additional reasons may be added in the future. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// AlbumRestrictionObjectReason.mo
/// Enum values: #market, #product, #explicit

module {
    public type AlbumRestrictionObjectReason = {
        #market;
        #product;
        #explicit;
    };

    public module JSON {
        public func toCandidValue(value : AlbumRestrictionObjectReason) : Candid.Candid =
            switch (value) {
                case (#market) #Text("market");
                case (#product) #Text("product");
                case (#explicit) #Text("explicit");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?AlbumRestrictionObjectReason =
            switch (candid) {
                case (#Text("market")) ?#market;
                case (#Text("product")) ?#product;
                case (#Text("explicit")) ?#explicit;
                case _ null;
            };

        public func toText(value : AlbumRestrictionObjectReason) : Text =
            switch (value) {
                case (#market) "market";
                case (#product) "product";
                case (#explicit) "explicit";
            };
    };
};
