import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ItemTypeInner.mo
/// Enum values: #album, #artist, #playlist, #track, #show, #episode, #audiobook

module {
    public type ItemTypeInner = {
        #album;
        #artist;
        #playlist;
        #track;
        #show;
        #episode;
        #audiobook;
    };

    public module JSON {
        public func toCandidValue(value : ItemTypeInner) : Candid.Candid =
            switch (value) {
                case (#album) #Text("album");
                case (#artist) #Text("artist");
                case (#playlist) #Text("playlist");
                case (#track) #Text("track");
                case (#show) #Text("show");
                case (#episode) #Text("episode");
                case (#audiobook) #Text("audiobook");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?ItemTypeInner =
            switch (candid) {
                case (#Text("album")) ?#album;
                case (#Text("artist")) ?#artist;
                case (#Text("playlist")) ?#playlist;
                case (#Text("track")) ?#track;
                case (#Text("show")) ?#show;
                case (#Text("episode")) ?#episode;
                case (#Text("audiobook")) ?#audiobook;
                case _ null;
            };

        public func toText(value : ItemTypeInner) : Text =
            switch (value) {
                case (#album) "album";
                case (#artist) "artist";
                case (#playlist) "playlist";
                case (#track) "track";
                case (#show) "show";
                case (#episode) "episode";
                case (#audiobook) "audiobook";
            };
    };
};
