package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    /**
     * 根据条件分页查询市场活动
     * @param map
     * @return
     */
    List<Activity> queryActivityByConditionForPage(Map<String, Object> map);

    /**
     * 根据条件查询市场活动记录总条数
     * @param map
     * @return
     */
    int queryCountOfActivityByCondition(Map<String, Object> map);
}
