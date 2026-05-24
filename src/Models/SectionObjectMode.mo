/// Indicates the modality (major or minor) of a section, the type of scale from which its melodic content is derived. This field will contain a 0 for \"minor\", a 1 for \"major\", or a -1 for no result. Note that the major key (e.g. C major) could more likely be confused with the minor key at 3 semitones lower (e.g. A minor) as both keys carry the same pitches.
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// SectionObjectMode.mo
/// Enum values: #minus_1, #_0_, #_1_

module {
    public type SectionObjectMode = {
        #minus_1;
        #_0_;
        #_1_;
    };

    public module JSON {
        public func toCandidValue(value : SectionObjectMode) : Candid.Candid =
            switch (value) {
                case (#minus_1) #Int(-1);
                case (#_0_) #Int(0);
                case (#_1_) #Int(1);
            };

        public func fromCandidValue(candid : Candid.Candid) : ?SectionObjectMode =
            switch (candid) {
                case (#Int(-1)) ?#minus_1;
                case (#Int(0)) ?#_0_;
                case (#Int(1)) ?#_1_;
                case _ null;
            };

        public func toText(value : SectionObjectMode) : Text =
            switch (value) {
                case (#minus_1) debug_show(-1);
                case (#_0_) debug_show(0);
                case (#_1_) debug_show(1);
            };
    };
};
