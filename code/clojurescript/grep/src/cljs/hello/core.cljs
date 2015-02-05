(ns hello.core
    (:require [reagent.core :as reagent :refer [atom]]
              [clojure.string :as string]
              [pani.cljs.core :as pani]))

(def firebase-app-url "https://hackerscool.firebaseio.com/")
(def r (pani/root (str firebase-app-url "grep/search")))

;; State
(def state (atom {:doc {}}))

(defn set-value! [id value]
  (swap! state assoc-in [:doc id] value))

(defn save-value! [id value]
;;   (pani/set! r id value)
  )

(defn set-and-save-value! [id value]
  (set-value! id value)
  (save-value! id value))

(defn get-value [id]
  (get-in @state [:doc id]))

;; Views
(comment
  (def items [{:results "ata\nmama\nteta\n" :request {:query "family"}}, {:results "foo\nbar\nbaz\nwoz\n" :request {:query "nerds"}}])
  (result-list items)
  (hello "rok" "39")
  (into [] (vals (@state :doc)))
  (result-list (vals (@state :doc)))
)

(defn result-list [items]
  [:div
    (for [item items]
      [:div (result-item item)])])

(defn result-item [item]
  [:div
    [:div.x-header.x-relative
      [:div.x-kode (get-in item [:request :query])]
      [:div.x-top-right.x-kode
        [:span.glyphicon.glyphicon-refresh]]]
    [:div.x-code-lines
      (for [line (string/split-lines (get-in item [:results]))]
        [result-line line])]])

(defn result-line [line]
  (let [
        copied (atom false)
        touch-and-copy #(do
                         (reset! copied (not @copied))
                         (pani/set! r :clipboard line)
                         (js/console.log "COPIED to Firebase")
                         )
        ]
    (fn []
  [:div.x-code
   {:class (if @copied "x-copied")
    :on-touch-start #(touch-and-copy %)
    :on-mouse-down #(touch-and-copy %)
    }
   (strip-filename line)])))

(defn strip-filename [grep-line]
  (let [filtered-line (re-find #"[-:].*" grep-line)]
    (if filtered-line
      (subs filtered-line 1))))

(defn current-page []
   [:div
    [result-list (reverse (into [] (vals (@state :doc))))]])

;; Initialize app
(defn init! []
  (js/React.initializeTouchEvents true)
  (pani/bind r :child_added :response #(set-value! (keyword (get % :name)) (get % :val) ))
;;   (pani/bind r :child_added :response #(js/console.log (clj->js (get % :val)) ))
  (reagent/render-component [current-page] (.getElementById js/document "app")))
