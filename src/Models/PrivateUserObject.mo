
import { type ExplicitContentSettingsObject; JSON = ExplicitContentSettingsObject } "./ExplicitContentSettingsObject";

import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";

import { type FollowersObject; JSON = FollowersObject } "./FollowersObject";

import { type ImageObject; JSON = ImageObject } "./ImageObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// PrivateUserObject.mo

module {
    /// The required-fields slice of PrivateUserObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express PrivateUserObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        country : ?Text;
        display_name : ?Text;
        email : ?Text;
        explicit_content : ?ExplicitContentSettingsObject;
        external_urls : ?ExternalUrlObject;
        followers : ?FollowersObject;
        href : ?Text;
        id : ?Text;
        images : ?[ImageObject];
        product : ?Text;
        type_ : ?Text;
        uri : ?Text;
    };

    public type PrivateUserObject = Required and Optional;

    public module JSON {
        // `init` constructs a PrivateUserObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { PrivateUserObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : PrivateUserObject {
            let ?res = from_candid(to_candid(required)) : ?PrivateUserObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : PrivateUserObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.country) {
                case (?v__) List.add(buf, ("country", #Text(v__)));
                case null ();
            };
            switch (value.display_name) {
                case (?v__) List.add(buf, ("display_name", #Text(v__)));
                case null ();
            };
            switch (value.email) {
                case (?v__) List.add(buf, ("email", #Text(v__)));
                case null ();
            };
            switch (value.explicit_content) {
                case (?v__) List.add(buf, ("explicit_content", ExplicitContentSettingsObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.external_urls) {
                case (?v__) List.add(buf, ("external_urls", ExternalUrlObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.followers) {
                case (?v__) List.add(buf, ("followers", FollowersObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.href) {
                case (?v__) List.add(buf, ("href", #Text(v__)));
                case null ();
            };
            switch (value.id) {
                case (?v__) List.add(buf, ("id", #Text(v__)));
                case null ();
            };
            switch (value.images) {
                case (?v__) List.add(buf, ("images", #Array(Array.map<ImageObject, Candid.Candid>(v__, ImageObject.toCandidValue))));
                case null ();
            };
            switch (value.product) {
                case (?v__) List.add(buf, ("product", #Text(v__)));
                case null ();
            };
            switch (value.type_) {
                case (?v__) List.add(buf, ("type", #Text(v__)));
                case null ();
            };
            switch (value.uri) {
                case (?v__) List.add(buf, ("uri", #Text(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?PrivateUserObject =
            switch (candid) {
                case (#Record(fields)) {
                    let country : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "country")) {
                        case (?country_field) ((switch (country_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let display_name : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "display_name")) {
                        case (?display_name_field) ((switch (display_name_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let email : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "email")) {
                        case (?email_field) ((switch (email_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let explicit_content : ?ExplicitContentSettingsObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "explicit_content")) {
                        case (?explicit_content_field) (ExplicitContentSettingsObject.fromCandidValue(explicit_content_field.1));
                        case null null;
                    };
                    let external_urls : ?ExternalUrlObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "external_urls")) {
                        case (?external_urls_field) (ExternalUrlObject.fromCandidValue(external_urls_field.1));
                        case null null;
                    };
                    let followers : ?FollowersObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "followers")) {
                        case (?followers_field) (FollowersObject.fromCandidValue(followers_field.1));
                        case null null;
                    };
                    let href : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "href")) {
                        case (?href_field) ((switch (href_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let id : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "id")) {
                        case (?id_field) ((switch (id_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let images : ?[ImageObject] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "images")) {
                        case (?images_field) ((switch (images_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<ImageObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = ImageObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    let product : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "product")) {
                        case (?product_field) ((switch (product_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let type_ : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type")) {
                        case (?type__field) ((switch (type__field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let uri : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri")) {
                        case (?uri_field) ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    ?{
                        country;
                        display_name;
                        email;
                        explicit_content;
                        external_urls;
                        followers;
                        href;
                        id;
                        images;
                        product;
                        type_;
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
