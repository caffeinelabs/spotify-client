
import { type ArtistObject; JSON = ArtistObject } "./ArtistObject";

import { type ExternalIdObject; JSON = ExternalIdObject } "./ExternalIdObject";

import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";

import { type FollowersObject; JSON = FollowersObject } "./FollowersObject";

import { type ImageObject; JSON = ImageObject } "./ImageObject";

import { type SimplifiedAlbumObject; JSON = SimplifiedAlbumObject } "./SimplifiedAlbumObject";

import { type SimplifiedArtistObject; JSON = SimplifiedArtistObject } "./SimplifiedArtistObject";

import { type TrackObject; JSON = TrackObject } "./TrackObject";

import { type TrackObjectType; JSON = TrackObjectType } "./TrackObjectType";

import { type TrackRestrictionObject; JSON = TrackRestrictionObject } "./TrackRestrictionObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// GetUsersTopArtistsAndTracks200ResponseAllOfItemsInner.mo
// Discriminator-oneOf — wire is a flat object whose `type`
// field selects the schema. Branches' `toCandidValue` already include that field, so dispatch
// is just a forward call (no re-wrapping).

module {
    public type GetUsersTopArtistsAndTracks200ResponseAllOfItemsInner = {
        #artist : ArtistObject;
        #track : TrackObject;
    };

    public module JSON {
        public func toCandidValue(value : GetUsersTopArtistsAndTracks200ResponseAllOfItemsInner) : Candid.Candid =
            switch (value) {
                case (#artist(v)) ArtistObject.toCandidValue(v);
                case (#track(v)) TrackObject.toCandidValue(v);
            };

        public func toText(value : GetUsersTopArtistsAndTracks200ResponseAllOfItemsInner) : Text =
            switch (value) {
                case (#artist(_)) "artist";
                case (#track(_)) "track";
            };

        public func fromCandidValue(candid : Candid.Candid) : ?GetUsersTopArtistsAndTracks200ResponseAllOfItemsInner =
            switch (candid) {
                case (#Record(fields)) {
                    let ?discPair = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type") else return null;
                    switch (discPair.1) {
                        case (#Text(disc)) {
                            switch (disc) {
                                case ("artist") {
                                    let ?inner = ArtistObject.fromCandidValue(candid) else return null;
                                    ?#artist(inner);
                                };
                                case ("track") {
                                    let ?inner = TrackObject.fromCandidValue(candid) else return null;
                                    ?#track(inner);
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
