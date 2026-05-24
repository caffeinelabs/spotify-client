
import { type EpisodeBaseReleaseDatePrecision; JSON = EpisodeBaseReleaseDatePrecision } "./EpisodeBaseReleaseDatePrecision";

import { type EpisodeBaseType; JSON = EpisodeBaseType } "./EpisodeBaseType";

import { type EpisodeRestrictionObject; JSON = EpisodeRestrictionObject } "./EpisodeRestrictionObject";

import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";

import { type ImageObject; JSON = ImageObject } "./ImageObject";

import { type ResumePointObject; JSON = ResumePointObject } "./ResumePointObject";

import { type SimplifiedShowObject; JSON = SimplifiedShowObject } "./SimplifiedShowObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// EpisodeObject.mo

module {
    /// The required-fields slice of EpisodeObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        /// A description of the episode. HTML tags are stripped away from this field, use `html_description` field in case HTML tags are needed. 
        description : Text;
        /// A description of the episode. This field may contain HTML tags. 
        html_description : Text;
        /// The episode length in milliseconds. 
        duration_ms : Int;
        /// Whether or not the episode has explicit content (true = yes it does; false = no it does not OR unknown). 
        explicit : Bool;
        /// External URLs for this episode. 
        external_urls : ExternalUrlObject;
        /// A link to the Web API endpoint providing full details of the episode. 
        href : Text;
        /// The [Spotify ID](/documentation/web-api/concepts/spotify-uris-ids) for the episode. 
        id : Text;
        /// The cover art for the episode in various sizes, widest first. 
        images : [ImageObject];
        /// True if the episode is hosted outside of Spotify's CDN. 
        is_externally_hosted : Bool;
        /// True if the episode is playable in the given market. Otherwise false. 
        is_playable : Bool;
        /// A list of the languages used in the episode, identified by their [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639) code. 
        languages : [Text];
        /// The name of the episode. 
        name : Text;
        /// The date the episode was first released, for example `\"1981-12-15\"`. Depending on the precision, it might be shown as `\"1981\"` or `\"1981-12\"`. 
        release_date : Text;
        release_date_precision : EpisodeBaseReleaseDatePrecision;
        type_ : EpisodeBaseType;
        /// The [Spotify URI](/documentation/web-api/concepts/spotify-uris-ids) for the episode. 
        uri : Text;
        /// The show on which the episode belongs. 
        show : SimplifiedShowObject;
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express EpisodeObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        audio_preview_url : ?Text;
        language : ?Text;
        resume_point : ?ResumePointObject;
        restrictions : ?EpisodeRestrictionObject;
    };

    public type EpisodeObject = Required and Optional;

    public module JSON {
        // `init` constructs a EpisodeObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { EpisodeObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : EpisodeObject {
            let ?res = from_candid(to_candid(required)) : ?EpisodeObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : EpisodeObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.audio_preview_url) {
                case (?v__) List.add(buf, ("audio_preview_url", #Text(v__)));
                case null ();
            };
            List.add(buf, ("description", #Text(value.description)));
            List.add(buf, ("html_description", #Text(value.html_description)));
            List.add(buf, ("duration_ms", #Int(value.duration_ms)));
            List.add(buf, ("explicit", #Bool(value.explicit)));
            List.add(buf, ("external_urls", ExternalUrlObject.toCandidValue(value.external_urls)));
            List.add(buf, ("href", #Text(value.href)));
            List.add(buf, ("id", #Text(value.id)));
            List.add(buf, ("images", #Array(Array.map<ImageObject, Candid.Candid>(value.images, ImageObject.toCandidValue))));
            List.add(buf, ("is_externally_hosted", #Bool(value.is_externally_hosted)));
            List.add(buf, ("is_playable", #Bool(value.is_playable)));
            switch (value.language) {
                case (?v__) List.add(buf, ("language", #Text(v__)));
                case null ();
            };
            List.add(buf, ("languages", #Array(Array.map<Text, Candid.Candid>(value.languages, func(s : Text) : Candid.Candid = #Text(s)))));
            List.add(buf, ("name", #Text(value.name)));
            List.add(buf, ("release_date", #Text(value.release_date)));
            List.add(buf, ("release_date_precision", EpisodeBaseReleaseDatePrecision.toCandidValue(value.release_date_precision)));
            switch (value.resume_point) {
                case (?v__) List.add(buf, ("resume_point", ResumePointObject.toCandidValue(v__)));
                case null ();
            };
            List.add(buf, ("type", EpisodeBaseType.toCandidValue(value.type_)));
            List.add(buf, ("uri", #Text(value.uri)));
            switch (value.restrictions) {
                case (?v__) List.add(buf, ("restrictions", EpisodeRestrictionObject.toCandidValue(v__)));
                case null ();
            };
            List.add(buf, ("show", SimplifiedShowObject.toCandidValue(value.show)));
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?EpisodeObject =
            switch (candid) {
                case (#Record(fields)) {
                    let audio_preview_url : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "audio_preview_url")) {
                        case (?audio_preview_url_field) ((switch (audio_preview_url_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let ?description_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "description") else return null;
                    let ?description = ((switch (description_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?html_description_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "html_description") else return null;
                    let ?html_description = ((switch (html_description_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?duration_ms_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "duration_ms") else return null;
                    let ?duration_ms = ((switch (duration_ms_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null })) else return null;
                    let ?explicit_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "explicit") else return null;
                    let ?explicit = ((switch (explicit_field.1) { case (#Bool(b)) ?b; case _ null })) else return null;
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
                    let ?is_externally_hosted_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "is_externally_hosted") else return null;
                    let ?is_externally_hosted = ((switch (is_externally_hosted_field.1) { case (#Bool(b)) ?b; case _ null })) else return null;
                    let ?is_playable_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "is_playable") else return null;
                    let ?is_playable = ((switch (is_playable_field.1) { case (#Bool(b)) ?b; case _ null })) else return null;
                    let language : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "language")) {
                        case (?language_field) ((switch (language_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let ?languages_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "languages") else return null;
                    let ?languages = ((switch (languages_field.1) {
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
                    let ?name_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "name") else return null;
                    let ?name = ((switch (name_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?release_date_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "release_date") else return null;
                    let ?release_date = ((switch (release_date_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?release_date_precision_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "release_date_precision") else return null;
                    let ?release_date_precision = (EpisodeBaseReleaseDatePrecision.fromCandidValue(release_date_precision_field.1)) else return null;
                    let resume_point : ?ResumePointObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "resume_point")) {
                        case (?resume_point_field) (ResumePointObject.fromCandidValue(resume_point_field.1));
                        case null null;
                    };
                    let ?type__field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type") else return null;
                    let ?type_ = (EpisodeBaseType.fromCandidValue(type__field.1)) else return null;
                    let ?uri_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri") else return null;
                    let ?uri = ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let restrictions : ?EpisodeRestrictionObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "restrictions")) {
                        case (?restrictions_field) (EpisodeRestrictionObject.fromCandidValue(restrictions_field.1));
                        case null null;
                    };
                    let ?show_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "show") else return null;
                    let ?show = (SimplifiedShowObject.fromCandidValue(show_field.1)) else return null;
                    ?{
                        audio_preview_url;
                        description;
                        html_description;
                        duration_ms;
                        explicit;
                        external_urls;
                        href;
                        id;
                        images;
                        is_externally_hosted;
                        is_playable;
                        language;
                        languages;
                        name;
                        release_date;
                        release_date_precision;
                        resume_point;
                        type_;
                        uri;
                        restrictions;
                        show;
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
