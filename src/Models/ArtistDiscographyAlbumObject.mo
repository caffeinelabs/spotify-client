
import { type AlbumBaseAlbumType; JSON = AlbumBaseAlbumType } "./AlbumBaseAlbumType";

import { type AlbumBaseReleaseDatePrecision; JSON = AlbumBaseReleaseDatePrecision } "./AlbumBaseReleaseDatePrecision";

import { type AlbumBaseType; JSON = AlbumBaseType } "./AlbumBaseType";

import { type AlbumRestrictionObject; JSON = AlbumRestrictionObject } "./AlbumRestrictionObject";

import { type ArtistDiscographyAlbumObjectAllOfAlbumGroup; JSON = ArtistDiscographyAlbumObjectAllOfAlbumGroup } "./ArtistDiscographyAlbumObjectAllOfAlbumGroup";

import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";

import { type ImageObject; JSON = ImageObject } "./ImageObject";

import { type SimplifiedArtistObject; JSON = SimplifiedArtistObject } "./SimplifiedArtistObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ArtistDiscographyAlbumObject.mo

module {
    /// The required-fields slice of ArtistDiscographyAlbumObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        album_type : AlbumBaseAlbumType;
        /// The number of tracks in the album.
        total_tracks : Int;
        /// The markets in which the album is available: [ISO 3166-1 alpha-2 country codes](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2). _**NOTE**: an album is considered available in a market when at least 1 of its tracks is available in that market._ 
        available_markets : [Text];
        /// Known external URLs for this album. 
        external_urls : ExternalUrlObject;
        /// A link to the Web API endpoint providing full details of the album. 
        href : Text;
        /// The [Spotify ID](/documentation/web-api/concepts/spotify-uris-ids) for the album. 
        id : Text;
        /// The cover art for the album in various sizes, widest first. 
        images : [ImageObject];
        /// The name of the album. In case of an album takedown, the value may be an empty string. 
        name : Text;
        /// The date the album was first released. 
        release_date : Text;
        release_date_precision : AlbumBaseReleaseDatePrecision;
        type_ : AlbumBaseType;
        /// The [Spotify URI](/documentation/web-api/concepts/spotify-uris-ids) for the album. 
        uri : Text;
        /// The artists of the album. Each artist object includes a link in `href` to more detailed information about the artist. 
        artists : [SimplifiedArtistObject];
        album_group : ArtistDiscographyAlbumObjectAllOfAlbumGroup;
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express ArtistDiscographyAlbumObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        restrictions : ?AlbumRestrictionObject;
    };

    public type ArtistDiscographyAlbumObject = Required and Optional;

    public module JSON {
        // `init` constructs a ArtistDiscographyAlbumObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { ArtistDiscographyAlbumObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : ArtistDiscographyAlbumObject {
            let ?res = from_candid(to_candid(required)) : ?ArtistDiscographyAlbumObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : ArtistDiscographyAlbumObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            List.add(buf, ("album_type", AlbumBaseAlbumType.toCandidValue(value.album_type)));
            List.add(buf, ("total_tracks", #Int(value.total_tracks)));
            List.add(buf, ("available_markets", #Array(Array.map<Text, Candid.Candid>(value.available_markets, func(s : Text) : Candid.Candid = #Text(s)))));
            List.add(buf, ("external_urls", ExternalUrlObject.toCandidValue(value.external_urls)));
            List.add(buf, ("href", #Text(value.href)));
            List.add(buf, ("id", #Text(value.id)));
            List.add(buf, ("images", #Array(Array.map<ImageObject, Candid.Candid>(value.images, ImageObject.toCandidValue))));
            List.add(buf, ("name", #Text(value.name)));
            List.add(buf, ("release_date", #Text(value.release_date)));
            List.add(buf, ("release_date_precision", AlbumBaseReleaseDatePrecision.toCandidValue(value.release_date_precision)));
            switch (value.restrictions) {
                case (?v__) List.add(buf, ("restrictions", AlbumRestrictionObject.toCandidValue(v__)));
                case null ();
            };
            List.add(buf, ("type", AlbumBaseType.toCandidValue(value.type_)));
            List.add(buf, ("uri", #Text(value.uri)));
            List.add(buf, ("artists", #Array(Array.map<SimplifiedArtistObject, Candid.Candid>(value.artists, SimplifiedArtistObject.toCandidValue))));
            List.add(buf, ("album_group", ArtistDiscographyAlbumObjectAllOfAlbumGroup.toCandidValue(value.album_group)));
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?ArtistDiscographyAlbumObject =
            switch (candid) {
                case (#Record(fields)) {
                    let ?album_type_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "album_type") else return null;
                    let ?album_type = (AlbumBaseAlbumType.fromCandidValue(album_type_field.1)) else return null;
                    let ?total_tracks_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "total_tracks") else return null;
                    let ?total_tracks = ((switch (total_tracks_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null })) else return null;
                    let ?available_markets_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "available_markets") else return null;
                    let ?available_markets = ((switch (available_markets_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<Text>();
                            for (c__ in xs__.values()) {
                                let #Text(s__) = c__ else return null;
                                List.add(buf__, s__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    let ?external_urls_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "external_urls") else return null;
                    let ?external_urls = (ExternalUrlObject.fromCandidValue(external_urls_field.1)) else return null;
                    let ?href_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "href") else return null;
                    let ?href = ((switch (href_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?id_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "id") else return null;
                    let ?id = ((switch (id_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?images_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "images") else return null;
                    let ?images = ((switch (images_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<ImageObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = ImageObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    let ?name_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "name") else return null;
                    let ?name = ((switch (name_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?release_date_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "release_date") else return null;
                    let ?release_date = ((switch (release_date_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?release_date_precision_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "release_date_precision") else return null;
                    let ?release_date_precision = (AlbumBaseReleaseDatePrecision.fromCandidValue(release_date_precision_field.1)) else return null;
                    let restrictions : ?AlbumRestrictionObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "restrictions")) {
                        case (?restrictions_field) (AlbumRestrictionObject.fromCandidValue(restrictions_field.1));
                        case null null;
                    };
                    let ?type__field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type") else return null;
                    let ?type_ = (AlbumBaseType.fromCandidValue(type__field.1)) else return null;
                    let ?uri_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri") else return null;
                    let ?uri = ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?artists_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "artists") else return null;
                    let ?artists = ((switch (artists_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<SimplifiedArtistObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = SimplifiedArtistObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    let ?album_group_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "album_group") else return null;
                    let ?album_group = (ArtistDiscographyAlbumObjectAllOfAlbumGroup.fromCandidValue(album_group_field.1)) else return null;
                    ?{
                        album_type;
                        total_tracks;
                        available_markets;
                        external_urls;
                        href;
                        id;
                        images;
                        name;
                        release_date;
                        release_date_precision;
                        restrictions;
                        type_;
                        uri;
                        artists;
                        album_group;
                    };
                };
                case _ null;
            };
    };

    /// Re-export of `JSON.init` at the outer module level. Three import shapes
    /// all reach the same function:
    ///
    ///   - `import T "...";                                     T.init {…}`     // whole-module
    ///   - `import { type T; JSON = T } "...";                  T.init {…}`     // JSON-alias
    ///   - `import { type T; JSON = T; init = myInit } "...";   myInit {…}`     // explicit rename
    ///
    /// The third form is handy when several models would all be reachable
    /// as `T.init` and you want each bound to a distinct local name.
    public let init = JSON.init;
};
