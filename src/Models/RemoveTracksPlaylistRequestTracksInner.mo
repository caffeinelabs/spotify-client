import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// RemoveTracksPlaylistRequestTracksInner.mo

module {
    /// The required-fields slice of RemoveTracksPlaylistRequestTracksInner — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express RemoveTracksPlaylistRequestTracksInner as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        uri : ?Text;
    };

    public type RemoveTracksPlaylistRequestTracksInner = Required and Optional;

    public module JSON {
        // `init` constructs a RemoveTracksPlaylistRequestTracksInner from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { RemoveTracksPlaylistRequestTracksInner.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : RemoveTracksPlaylistRequestTracksInner {
            let ?res = from_candid(to_candid(required)) : ?RemoveTracksPlaylistRequestTracksInner else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : RemoveTracksPlaylistRequestTracksInner) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.uri) {
                case (?v__) List.add(buf, ("uri", #Text(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?RemoveTracksPlaylistRequestTracksInner =
            switch (candid) {
                case (#Record(fields)) {
                    let uri : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri")) {
                        case (?uri_field) ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    ?{
                        uri;
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
