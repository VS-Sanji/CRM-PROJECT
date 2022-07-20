package com.bjpowernode.crm.workbench.service;



import com.bjpowernode.crm.workbench.domain.Activity;


import java.util.List;
import java.util.Map;

public interface ActivityService {

    /**
     * 保存创建的市场活动到数据库中
     * @param activity
     * @return
     */
    int saveCreateActivity(Activity activity);

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
