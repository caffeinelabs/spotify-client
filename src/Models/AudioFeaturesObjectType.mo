/// The object type. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// AudioFeaturesObjectType.mo
/// Enum values: #audio_features

module {
    public type AudioFeaturesObjectType = {
        #audio_features;
    };

    public module JSON {
        public func toCandidValue(value : AudioFeaturesObjectType) : Candid.Candid =
            switch (value) {
                case (#audio_features) #Text("audio_features");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?AudioFeaturesObjectType =
            switch (candid) {
                case (#Text("audio_features")) ?#audio_features;
                case _ null;
            };

        public func toText(value : AudioFeaturesObjectType) : Text =
            switch (value) {
                case (#audio_features) "audio_features";
            };
    };
};
