(ns hello.core
    (:require [reagent.core :as reagent :refer [atom]]
              [clojure.string :as string]
              [pani.cljs.core :as pani]))

(def firebase-app-url "https://hackerscool.firebaseio.com/")
(def r (pani/root (str firebase-app-url "grep/search")))

;; State
(def state (atom {:doc {}})) ;; watchers

(comment
  @state ;; dereferencing is watched by Reagent
)

(defn set-value! [id value]
  (swap! state assoc-in [:doc id] value)) ;; compare & set

(defn delete-value! [id]
  (swap! state update-in [:doc] dissoc id))

(defn get-value [id]
  (get-in @state [:doc id]))

(defn strip-filename [grep-line]
  (let [filtered-line (re-find #"[-:].*" grep-line)]
    (if filtered-line
      (subs filtered-line 1))))

;; Views
(defn result-line [line]
  (let [
        copied (atom false)
        touchStartTime (atom 0)
        stripped-line (strip-filename line)
        handle-touch-start (fn [event] 
                              (reset! touchStartTime (.getTime (js/Date.)))
                              (js/console.log "handle-touch-start" @touchStartTime)
                              )
        handle-touch-end (fn [event]
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
                            ))
        ]
    (fn []
  [:div.x-code
   {:class (if @copied "x-copied")
    :on-touch-start #(handle-touch-start %)
    :on-touch-end #(handle-touch-end %)
;;     :on-mouse-down #(handle-touch-start %)
;;     :on-mouse-up #(handle-touch-end %)
    }
   stripped-line])))

(defn result-item [item]
  [:div
    [:div.x-header.x-relative
      [:div.x-kode (get-in item [:request :query])]
      [:div.x-top-right.x-kode
        [:span.glyphicon.glyphicon-refresh]]]
    [:div.x-code-lines
      (for [line (take 6 (filter #(if (not= (string/trim %) "") true false) (string/split-lines (get-in item [:results]))))]
        [result-line line])]])

(defn result-list [items]
  [:div
    (for [item items]
      [:div (result-item item)])])

(defn current-page []
   [:div
    [result-list (reverse (into [] (vals (@state :doc))))]])

;; Initialize app
(defn init! []
  (js/React.initializeTouchEvents true)
  (pani/bind r :child_added :response #(do
                                         (set-value! (keyword (get % :name)) (get % :val) )
                                         (js/console.log ":child_added" (get % :name) (clj->js (get % :val)))
                                         ))
  (pani/bind r :child_removed :response #(do
                                         (js/console.log ":child_removed" (keyword (get % :name)) (get % :name) (clj->js %))
                                         (delete-value! (keyword (get % :name)))
                                         ))
  (reagent/render-component [current-page] (.getElementById js/document "app")))
