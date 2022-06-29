package com.bjpowernode.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {
    /*
        理论上，给controller方法分配url需要一个完整的路径：http：//127.0.0.1:8080/crm/
        为了简便，springmvc规定，协议：//ip：port/应用名称必须省去，用/代表应用根目录下的/
     */
    @RequestMapping("/")
    public String index(){
        //请求转发
        return "index";
    }
}
