
import { type ImageObject; JSON = ImageObject } "./ImageObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// CategoryObject.mo

module {
    /// The required-fields slice of CategoryObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        /// A link to the Web API endpoint returning full details of the category. 
        href : Text;
        /// The category icon, in various sizes. 
        icons : [ImageObject];
        /// The [Spotify category ID](/documentation/web-api/concepts/spotify-uris-ids) of the category. 
        id : Text;
        /// The name of the category. 
        name : Text;
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express CategoryObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
    };

    public type CategoryObject = Required and Optional;

    public module JSON {
        // `init` constructs a CategoryObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { CategoryObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : CategoryObject {
            let ?res = from_candid(to_candid(required)) : ?CategoryObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : CategoryObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            List.add(buf, ("href", #Text(value.href)));
            List.add(buf, ("icons", #Array(Array.map<ImageObject, Candid.Candid>(value.icons, ImageObject.toCandidValue))));
            List.add(buf, ("id", #Text(value.id)));
            List.add(buf, ("name", #Text(value.name)));
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?CategoryObject =
            switch (candid) {
                case (#Record(fields)) {
                    let ?href_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "href") else return null;
                    let ?href = ((switch (href_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?icons_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "icons") else return null;
                    let ?icons = ((switch (icons_field.1) {
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
                    let ?id_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "id") else return null;
                    let ?id = ((switch (id_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?name_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "name") else return null;
                    let ?name = ((switch (name_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    ?{
                        href;
                        icons;
                        id;
                        name;
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
