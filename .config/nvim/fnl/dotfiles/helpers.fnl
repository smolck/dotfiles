(module dotfiles.helpers
  {require {a aniseed.core
            nvim aniseed.nvim}})

(defn plug [path config]
  (nvim.validate {:path [path "s"]})
                  ;; TODO
                  ;; :config [config vim.tbl_islist "an array of packages"]})
  (nvim.fn.plug#begin path)
  (each [_ v (ipairs config)]
    (if
      (= (type v) "string") (nvim.fn.plug# v)
      (= (type v) "table") (do
                             (let [p (. v :package)]
                               (assert p "Must specify package.")
                               (tset v :package nil)
                               (vim.fn.plug# p v)
                               (tset v :package p)))))
  (nvim.fn.plug#end)
  (vim._update_package_paths))

(defn define-nvim-fn [func-name func]
  (tset nvim.fn func-name func))

(defn assoc [tbl kv-tbl]
  (let [tbl (or tbl {})]
    (each [k v (pairs kv-tbl)]
      (tset tbl k v))
    tbl))

(defn assoc-mut [tbl kv-tbl]
  (each [k v (pairs kv-tbl)]
    (tset tbl k v)))

;; See https://github.com/norcalli/nvim_utils/blob/master/lua/nvim_utils.lua
(defn nvim-create-augroups [defs]
  (each [group-name definition (pairs defs)]
    (nvim.command (.. "augroup " group-name))
    (nvim.command "autocmd!")
    (each [_ d (ipairs definition)]
      (nvim.command (table.concat (vim.tbl_flatten ["autocmd" d]) " ")))
    (nvim.command "augroup END")))
