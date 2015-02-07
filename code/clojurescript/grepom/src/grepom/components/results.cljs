(ns grepom.components.results ;; this is a path
  (:require [om.core :as om]
            [clojure.string :as string]
            [ankha.core :as ankha]
            [sablono.core :as html :refer-macros [html]]))

(defn strip-filename [grep-line]
  (when-let [filtered-line (re-find #"[-:].*" grep-line)]
    (subs filtered-line 1)))

(defn result-line [payload owner opts]
  (om/component
    (let [line (strip-filename payload)] 
    (html [:div line])))
  )

(defn result-item [payload owner opts]
  (reify
    om/IDisplayName
    (display-name [_]
                  "ResultItem")
    om/IWillMount
    (will-mount [_]
             (om/set-state! owner :open? true))
    om/IRender
    (render [_]
	    (let [lines (->> (:results payload)
	                      string/split-lines
	                      (remove string/blank?) ;; (comp not string/empty?)
	                      (take 6))]
		    (html [:div 
		           [:div {:style {:background-color "orange"} 
                    	  :on-click (fn [event]
                                   (.preventDefault event)
                                   (om/update-state! owner :open? not))} 
              			  "Query:" (get-in payload [:request :query])]
             	   (when (om/get-state owner :open?)
		           	[:div "Result:" (om/build-all result-line lines)])])))))

(defn result-list [payload owner opts]
  (om/component 
    ;;(html [:div (map #(om/build result-item %) payload)])))
    (html [:div (om/build-all result-item payload)])))
