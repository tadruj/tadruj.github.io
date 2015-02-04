(ns hello.core
    (:require [reagent.core :as reagent :refer [atom]]
              [reagent.session :as session]
              [secretary.core :as secretary :include-macros true]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [pani.cljs.core :as pani])
    (:import goog.History))

(def firebase-app-url "https://hackerscool.firebaseio.com/hello_world")
(def r (pani/root firebase-app-url))

;; State
(def state (atom {:doc {}}))

(defn set-value! [id value]
  (swap! state assoc-in [:doc id] value))

(defn save-value! [id value]
  (pani/set! r id value))

(defn set-and-save-value! [id value]
  (set-value! id value)
  (save-value! id value))

(defn get-value [id]
  (get-in @state [:doc id]))

;; -------------------------
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

(defn home-page []
   [:div [:h2 "Hello world"]
    [:div
     [hello (get-value :name) (get-value :age)]
     [text-input :name "Name"]
     [text-input :age "Age"]
;;      [:a {:href "#/about"} "go to about page"]
     "ClojureScript + Reagent + Firebase together are 10 years old."
     ]])

(defn about-page []
  [:div [:h2 "About hello 3.1"]
   [:div [:a {:href "#/"} "go to the home page"]]])

(defn current-page []
  [:div [(session/get :current-page)]])

;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (session/put! :current-page #'home-page))

(secretary/defroute "/about" []
  (session/put! :current-page #'about-page))

;; -------------------------
;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;; -------------------------
;; Initialize app
(defn init! []
  (pani/bind r :value :name #(set-value! (keyword (get % :name)) (get % :val) ))
  (pani/bind r :value :age #(set-value! (keyword (get % :name)) (get % :val) ))
  (hook-browser-navigation!)
  (reagent/render-component [current-page] (.getElementById js/document "app")))
