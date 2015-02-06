(ns grepom.core
  (:require [om.core :as om]
            [clojure.string :as string]
            [ankha.core :as ankha]
            [sablono.core :as html :refer-macros [html]]))

(enable-console-print!)

(def app-state (atom {:docs [] :text "Hello world!" :example {:greeting "Aloha" :count 0}}))

(defn example [payload owner opts]
(reify 
  om/IRender
  (render [_]
          (html [:div 
                 [:p (:greeting payload)]
                 [:button {:on-click (fn [event] (om/transact! payload :count inc))} (:count payload)]]))
  om/IWillMount
  (will-mount [_]
              (print "example will-mount"))))

(defn strip-filename [grep-line]
  (when-let [filtered-line (re-find #"[-:].*" grep-line)]
    (subs filtered-line 1)))

(defn result-line [payload owner opts]
  (om/component
    (let [line (strip-filename payload)] 
    (html [:div line])))
  )

(defn result-item [payload owner opts]
  (om/component
    (let [lines (->> (:results payload)
                      string/split-lines
                      (remove string/blank?) ;; (comp not string/empty?)
                      (take 6))]
	    (html [:div 
	           [:div "Query:" (get-in payload [:request :query])]
	           [:div "Result:" (om/build-all result-line lines)]]))))

(defn result-list [payload owner opts]
  (om/component 
    ;;(html [:div (map #(om/build result-item %) payload)])))
    (html [:div (om/build-all result-item payload)])))

(om/root
  (fn [app owner]
    (reify om/IRender
      (render [_]
        (html [:div [:h1 (:text app)]
               (om/build example (:example app))
               (om/build result-list (:docs app))              
               [:div (om/build ankha/inspector app)]]))))
  app-state
  {:target (. js/document (getElementById "app"))})

(def firebase-app-url "https://hackerscool.firebaseio.com/")
(def r (js/Firebase. (str firebase-app-url "grep/search/response")))
(.on r "child_added" (fn [data] 
                       (let [blob (js->clj (.val data) :keywordize-keys true)]
                         (swap! app-state update-in [:docs] conj blob)
                         )))
