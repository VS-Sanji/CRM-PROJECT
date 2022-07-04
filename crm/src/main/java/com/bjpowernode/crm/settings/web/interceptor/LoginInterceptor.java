package com.bjpowernode.crm.settings.web.interceptor;

import com.bjpowernode.crm.commons.contants.Contants;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        //设置登录前拦截器，未登录不予放行，跳转登录界面进行登录
        if (httpServletRequest.getSession().getAttribute(Contants.SESSION_USER)==null){
            //这个拦截器不是交由springmvc接管的，所以需要我们自己手动写 重定向，手动重定向要加上项目名且不能写死，所以httpServletRequest.getContextPath()
            httpServletResponse.sendRedirect(httpServletRequest.getContextPath());
            //拦截
            return false;
        }
        //放行
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
