/// The object type. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// PublicUserObjectType.mo
/// Enum values: #user

module {
    public type PublicUserObjectType = {
        #user;
    };

    public module JSON {
        public func toCandidValue(value : PublicUserObjectType) : Candid.Candid =
            switch (value) {
                case (#user) #Text("user");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?PublicUserObjectType =
            switch (candid) {
                case (#Text("user")) ?#user;
                case _ null;
            };

        public func toText(value : PublicUserObjectType) : Text =
            switch (value) {
                case (#user) "user";
            };
    };
};
