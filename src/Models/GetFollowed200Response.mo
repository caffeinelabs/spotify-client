
import { type CursorPagingSimplifiedArtistObject; JSON = CursorPagingSimplifiedArtistObject } "./CursorPagingSimplifiedArtistObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// GetFollowed200Response.mo

module {
    /// The required-fields slice of GetFollowed200Response — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        artists : CursorPagingSimplifiedArtistObject;
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express GetFollowed200Response as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
    };

    public type GetFollowed200Response = Required and Optional;

    public module JSON {
        // `init` constructs a GetFollowed200Response from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { GetFollowed200Response.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : GetFollowed200Response {
            let ?res = from_candid(to_candid(required)) : ?GetFollowed200Response else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : GetFollowed200Response) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            List.add(buf, ("artists", CursorPagingSimplifiedArtistObject.toCandidValue(value.artists)));
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?GetFollowed200Response =
            switch (candid) {
                case (#Record(fields)) {
                    let ?artists_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "artists") else return null;
                    let ?artists = (CursorPagingSimplifiedArtistObject.fromCandidValue(artists_field.1)) else return null;
                    ?{
                        artists;
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
