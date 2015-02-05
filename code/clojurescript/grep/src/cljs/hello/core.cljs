(ns hello.core
    (:require [reagent.core :as reagent :refer [atom]]
              [clojure.string :as string]
              [pani.cljs.core :as pani]))

(def firebase-app-url "https://hackerscool.firebaseio.com/")
(def r (pani/root (str firebase-app-url "grep/search")))

;; State
(def state (atom {:doc     {}
                  :mobile? false}))

(defn set-value! [id value]
  (swap! state assoc-in [:doc id] value))

(defn delete-value! [id]
  (swap! state update-in [:doc] dissoc id))

(defn get-value [id]
  (get-in @state [:doc id]))

;; Normalizing helper
(defn is-mobile? [window]
  (boolean (.-orientation window)))

(defn normalize-touch-event-names [mobile? m]
  (if mobile?
    {:on-touch-start (or (:on-touch-start m)
                         (:on-mouse-down m))
     :on-touch-end   (or (:on-touch-end m)
                         (:on-mouse-up m))
     :on-touch       (or (:on-touch m)
                         (:on-click m))}
    {:on-mouse-down (or (:on-mouse-down m)
                        (:on-touch-start m))
     :on-mouse-up   (or (:on-mouse-up m)
                        (:on-touch-end m))
     :on-click      (or (:on-click m)
                        (:on-touch m))}))

;; Views
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
      (for [line (take 6 (filter #(if (not= (string/trim %) "") true false) (string/split-lines (get-in item [:results]))))]
        [result-line line])]])

(defn result-line [line]
  (let [
        copied             (atom false)
        touchStartTime     (atom 0)
        stripped-line      (strip-filename line)
        handle-touch-start (fn [event]
                             (do
                               (reset! touchStartTime (.getTime (js/Date.)))
                               (js/console.log "handle-touch-start" @touchStartTime)
                               ))
        handle-touch-end   (fn [event]
                             (do
                               (js/console.log  (> (- (.getTime (js/Date.)) @touchStartTime) 500)  (- (.getTime (js/Date.)) @touchStartTime))
                               (if (> (- (.getTime (js/Date.)) @touchStartTime) 500)
                                 (do
                                   (reset! copied true)
                                   (pani/set! r :clipboard stripped-line)
                                   (js/console.log "COPIED")
                                   )
                                 (do
                                   (reset! copied false)
                                   (js/console.log "NOT COPIED")
                                   )
                                 )))
        norm               (:norm-evts @state)
        ]
    (fn []
  [:div.x-code
   (merge {:class (if @copied "x-copied")}
          (norm {:on-touch-start #(handle-touch-start %)
                 :on-touch-end   #(handle-touch-end %)
                 :on-mouse-down  #(handle-touch-start %)
                 :on-mouse-up    #(handle-touch-end %)}))
   stripped-line])))

(defn strip-filename [grep-line]
  (let [filtered-line (re-find #"[-:].*" grep-line)]
    (if filtered-line
      (subs filtered-line 1))))

(defn current-page []
   [:div
    [result-list (reverse (into [] (vals (@state :doc))))]])

;; Initialize app
(defn init! []
  ;; Set mobile or not-mobile in app-state
  (if (is-mobile? js/window)
    (do
      (js/React.initializeTouchEvents true)
      (swap! state assoc :mobile? true)
      (swap! state assoc :norm-evts (partial normalize-touch-event-names true)))
    (swap! state assoc :norm-evts (partial normalize-touch-event-names false)))
  (pani/bind r :child_added :response #(do
                                         (set-value! (keyword (get % :name)) (get % :val) )
                                         (js/console.log ":child_added" (get % :name) (clj->js (get % :val)))
                                         ))
  (pani/bind r :child_removed :response #(do
                                         (js/console.log ":child_removed" (keyword (get % :name)) (get % :name) (clj->js %))
                                         (delete-value! (keyword (get % :name)))
                                         ))
  (reagent/render-component [current-page] (.getElementById js/document "app")))
