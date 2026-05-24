/// If `include_external=audio` is specified it signals that the client can play externally hosted audio content, and marks the content as playable in the response. By default externally hosted audio content is marked as unplayable in the response. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// IncludeExternal.mo
/// Enum values: #audio

module {
    public type IncludeExternal = {
        #audio;
    };

    public module JSON {
        public func toCandidValue(value : IncludeExternal) : Candid.Candid =
            switch (value) {
                case (#audio) #Text("audio");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?IncludeExternal =
            switch (candid) {
                case (#Text("audio")) ?#audio;
                case _ null;
            };

        public func toText(value : IncludeExternal) : Text =
            switch (value) {
                case (#audio) "audio";
            };
    };
};
