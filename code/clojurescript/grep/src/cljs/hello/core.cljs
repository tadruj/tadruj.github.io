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
(defn text-input [id label]
  [:div
   [:input {
            :type "text"
            :class "form-control"
            :placeholder label
            :value (get-value id)
            :onChange #(set-and-save-value! id (-> % .-target .-value))
            }]])

(defn hello [name age]
  [:div
   [:span "Hello my name is "]
   [:span name]
   [:span " and I'm "]
   [:span age]
   [:span " years old."]])

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
    [:div.title (get-in item [:request :query])]
    [:div
     (for [line (string/split-lines (get-in item [:results]))]
       [:div (strip-filename line)])
     ]])

(defn strip-filename [grep-line]
  (let [filtered-line (re-find #"[-:].*" grep-line)]
    (if filtered-line
      (subs filtered-line 1))))

(defn current-page []
   [:div
    [result-list (reverse (into [] (vals (@state :doc))))]
;;     [:h2 "Grep"]
;;     [:div
;;      [hello (get-value :name) (get-value :age)]
;;      [text-input :name "Name"]
;;      [text-input :age "Age"]
;;      "ClojureScript + Reagent + Firebase together are 10 years old."
;;      ]
    ])

;; Initialize app
(defn init! []
  (pani/bind r :child_added :response #(set-value! (keyword (get % :name)) (get % :val) ))
;;   (pani/bind r :child_added :response #(js/console.log (clj->js (get % :val)) ))
  (reagent/render-component [current-page] (.getElementById js/document "app")))
