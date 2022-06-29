package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.User;

import java.util.Map;

public interface UserService {
    /**
     * 根据账号和密码查询用户
     * @param map
     * @return
     */
    User queryUserByLoginActAndPwd(Map<String,Object> map);
}
