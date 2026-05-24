/// The object type. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ShowBaseType.mo
/// Enum values: #show

module {
    public type ShowBaseType = {
        #show;
    };

    public module JSON {
        public func toCandidValue(value : ShowBaseType) : Candid.Candid =
            switch (value) {
                case (#show) #Text("show");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?ShowBaseType =
            switch (candid) {
                case (#Text("show")) ?#show;
                case _ null;
            };

        public func toText(value : ShowBaseType) : Text =
            switch (value) {
                case (#show) "show";
            };
    };
};
