
import { type TrackObject; JSON = TrackObject } "./TrackObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// GetAnArtistsTopTracks200Response.mo

module {
    /// The required-fields slice of GetAnArtistsTopTracks200Response — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        tracks : [TrackObject];
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express GetAnArtistsTopTracks200Response as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
    };

    public type GetAnArtistsTopTracks200Response = Required and Optional;

    public module JSON {
        // `init` constructs a GetAnArtistsTopTracks200Response from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { GetAnArtistsTopTracks200Response.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : GetAnArtistsTopTracks200Response {
            let ?res = from_candid(to_candid(required)) : ?GetAnArtistsTopTracks200Response else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : GetAnArtistsTopTracks200Response) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            List.add(buf, ("tracks", #Array(Array.map<TrackObject, Candid.Candid>(value.tracks, TrackObject.toCandidValue))));
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?GetAnArtistsTopTracks200Response =
            switch (candid) {
                case (#Record(fields)) {
                    let ?tracks_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "tracks") else return null;
                    let ?tracks = ((switch (tracks_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<TrackObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = TrackObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    ?{
                        tracks;
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
