(defproject grepom "0.1.0-SNAPSHOT"
  :description "FIXME: write this!"
  :url "http://example.com/FIXME"

  :dependencies [[org.clojure/clojure "1.6.0"]
                 [org.clojure/clojurescript "0.0-2755"]
                 [org.clojure/core.async "0.1.346.0-17112a-alpha"]
                 [org.omcljs/om "0.8.8"]
                 [sablono "0.3.1"]
                 [ankha "0.1.5.1-21e6ac"]
                 [ff-om-draggable "0.0.18"]]

  :plugins [[lein-cljsbuild "1.0.4"]]

  :source-paths ["src" "target/classes"]

  :clean-targets ["out/grepom" "out/grepom.js"]

  :cljsbuild {
    :builds [{:id "dev"
              :source-paths ["src"]
              :compiler {
                :output-to "out/grepom.js"
                :output-dir "out"
                :optimizations :none
                :cache-analysis true
                :source-map true}}]})
