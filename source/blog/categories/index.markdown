---
layout: page
title: "categories"
date: 2014-11-02 19:16
comments: false
sharing: false
footer: false
layout: default
---

<div class="all-posts">
  <div class="article-list">  
    <div class="container">
      <div class="row">
        <div class="list-title col-md-offset-3 col-md-6">
          <h2>Categories</h2>
          {% for item in site.categories %}
            <h5>
              <a href="/blog/categories/{{ item[0] }}/">{{ item[0] | capitalize }}</a> [ {{ item[1].size }} ]
            </h5>
          {% endfor %}
        </div>
      </div>
    </div>
  </div>  
</div>  
