/// The precision with which `release_date` value is known. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// EpisodeBaseReleaseDatePrecision.mo
/// Enum values: #year, #month, #day

module {
    public type EpisodeBaseReleaseDatePrecision = {
        #year;
        #month;
        #day;
    };

    public module JSON {
        public func toCandidValue(value : EpisodeBaseReleaseDatePrecision) : Candid.Candid =
            switch (value) {
                case (#year) #Text("year");
                case (#month) #Text("month");
                case (#day) #Text("day");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?EpisodeBaseReleaseDatePrecision =
            switch (candid) {
                case (#Text("year")) ?#year;
                case (#Text("month")) ?#month;
                case (#Text("day")) ?#day;
                case _ null;
            };

        public func toText(value : EpisodeBaseReleaseDatePrecision) : Text =
            switch (value) {
                case (#year) "year";
                case (#month) "month";
                case (#day) "day";
            };
    };
};
