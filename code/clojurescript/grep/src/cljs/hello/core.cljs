(ns hello.core
    (:require [reagent.core :as reagent :refer [atom]]
              [clojure.string :as string]
              [pani.cljs.core :as pani]))

(def firebase-app-url "https://hackerscool.firebaseio.com/")
(def r (pani/root (str firebase-app-url "grep/search")))

;; State
(def state (atom {:doc {}})) ;; watchers

(defn set-value! [id value]
  (swap! state assoc-in [:doc id] value)) ;; compare & set

(defn delete-value! [id]
  (swap! state update-in [:doc] dissoc id))

(defn get-value [id]
  (get-in @state [:doc id]))

(defn strip-filename [grep-line]
  (when-let [filtered-line (re-find #"[-:].*" grep-line)]
    (subs filtered-line 1)))

;; Views
(defn result-line [line]
  (let [copied             (atom false)
        touch-start-time   (atom 0)
        stripped-line      (strip-filename line)
        handle-touch-start (fn [event] 
                              (reset! touch-start-time (.getTime (js/Date.))))
        handle-touch-end (fn [event]
                           (let [now (.getTime (js/Date.))
                                 threshold 500
                                 triggered? (> (- now @touch-start-time) threshold)] 
                            (if triggered?
                              (do
                                (reset! copied true)
                                (pani/set! r :clipboard stripped-line))
                              (reset! copied false))))]
      [:div.x-code
       {:class (if @copied "x-copied")
        :on-touch-start #(handle-touch-start %)
        :on-touch-end #(handle-touch-end %)
    ;;     :on-mouse-down #(handle-touch-start %)
    ;;     :on-mouse-up #(handle-touch-end %)
        }
       stripped-line]))

(defn result-item [item]
  [:div
    [:div.x-header.x-relative
      [:div.x-kode (get-in item [:request :query])]
      [:div.x-top-right.x-kode
        [:span.glyphicon.glyphicon-refresh]]]
    [:div.x-code-lines
      (let [lines (->> (:results item)
                      string/split-lines
                      (remove string/blank?) ;; (comp not string/empty?)
                      (take 6))]
        (map result-line lines))]])

(defn result-list [items]
  [:div
    (map result-item items)])

(defn current-page []
   [:div
    [result-list (->> (:doc @state) ;; this is a thrush operator
                      vals
                      (sort-by (comp - :time)))]])

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
