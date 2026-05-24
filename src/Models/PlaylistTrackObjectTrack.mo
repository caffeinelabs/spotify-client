/// Information about the track or episode.

import { type EpisodeBaseReleaseDatePrecision; JSON = EpisodeBaseReleaseDatePrecision } "./EpisodeBaseReleaseDatePrecision";

import { type EpisodeBaseType; JSON = EpisodeBaseType } "./EpisodeBaseType";

import { type EpisodeObject; JSON = EpisodeObject } "./EpisodeObject";

import { type EpisodeRestrictionObject; JSON = EpisodeRestrictionObject } "./EpisodeRestrictionObject";

import { type ExternalIdObject; JSON = ExternalIdObject } "./ExternalIdObject";

import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";

import { type ImageObject; JSON = ImageObject } "./ImageObject";

import { type ResumePointObject; JSON = ResumePointObject } "./ResumePointObject";

import { type SimplifiedAlbumObject; JSON = SimplifiedAlbumObject } "./SimplifiedAlbumObject";

import { type SimplifiedArtistObject; JSON = SimplifiedArtistObject } "./SimplifiedArtistObject";

import { type SimplifiedShowObject; JSON = SimplifiedShowObject } "./SimplifiedShowObject";

import { type TrackObject; JSON = TrackObject } "./TrackObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// PlaylistTrackObjectTrack.mo
// Discriminator-oneOf — wire is a flat object whose `type`
// field selects the schema. Branches' `toCandidValue` already include that field, so dispatch
// is just a forward call (no re-wrapping).

module {
    public type PlaylistTrackObjectTrack = {
        #track : TrackObject;
        #episode : EpisodeObject;
    };

    public module JSON {
        public func toCandidValue(value : PlaylistTrackObjectTrack) : Candid.Candid =
            switch (value) {
                case (#track(v)) TrackObject.toCandidValue(v);
                case (#episode(v)) EpisodeObject.toCandidValue(v);
            };

        public func toText(value : PlaylistTrackObjectTrack) : Text =
            switch (value) {
                case (#track(_)) "track";
                case (#episode(_)) "episode";
            };

        public func fromCandidValue(candid : Candid.Candid) : ?PlaylistTrackObjectTrack =
            switch (candid) {
                case (#Record(fields)) {
                    let ?discPair = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type") else return null;
                    switch (discPair.1) {
                        case (#Text(disc)) {
                            switch (disc) {
                                case ("track") {
                                    let ?inner = TrackObject.fromCandidValue(candid) else return null;
                                    ?#track(inner);
                                };
                                case ("episode") {
                                    let ?inner = EpisodeObject.fromCandidValue(candid) else return null;
                                    ?#episode(inner);
                                };
                                case _ null;
                            };
                        };
                        case _ null;
                    };
                };
                case _ null;
            };
    };
};
