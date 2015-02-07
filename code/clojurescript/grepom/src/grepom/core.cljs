(ns grepom.core
  (:require [om.core :as om]
            [clojure.string :as string]
            [ankha.core :as ankha]
            [sablono.core :as html :refer-macros [html]]
            [grepom.components.results :as c-result]
            [ff-om-draggable.core :as ff]))

(enable-console-print!)

(def app-state (atom {:docs [] 
                      :text "Hello world!" 
                      :example {:greeting "Aloha" :count 0} 
                      :position {:left 500 :top 20}}))

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

(om/root
  (fn [app owner]
    (reify om/IRender
      (render [_]
	      (let [docs (:docs app)
	            sorted-docs (->> docs
	                             (sort-by :time)
	                             reverse)] 
	        (html [:div [:h1 (:text app)]
	               (om/build example (:example app))
	               (om/build c-result/result-list sorted-docs)              
	               [:div (om/build (ff/draggable-item ankha/inspector [:position]) app)]])))))
  app-state
  {:target (. js/document (getElementById "app"))})

(def firebase-app-url "https://hackerscool.firebaseio.com/")
(def r (js/Firebase. (str firebase-app-url "grep/search/response")))
(.on r "child_added" (fn [data] 
                       (let [blob (merge {:key (.key data)} 
                                         (js->clj (.val data) :keywordize-keys true))]
                         (swap! app-state update-in [:docs] conj blob)
                         )))
(.on r "child_removed" (fn [data] 
                       (let [blob (js->clj (.val data) :keywordize-keys true)]
                         (js/console.log (.key data))
						 ;; (swap! app-state update-in [:docs] (fn [docs] (remove #(= deleted-key (:key %)) docs))                         
						 (swap! app-state update-in [:docs] (fn [docs] (vec (remove #(= (.key data) (:key %)) docs)))))))

