package com.hackcess.angel;

import java.util.List;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import com.hackcess.angel.verticalviewpager.FragmentPagerAdapter;

public class AlertPagerAdapter extends FragmentPagerAdapter {

    private final List<Fragment> fragments;

    public AlertPagerAdapter(FragmentManager fm, List fragments) {
        super(fm);
        this.fragments = fragments;
    }

    @Override
    public Fragment getItem(int position) {
        return this.fragments.get(position);
    }

    @Override
    public int getCount() {
        return this.fragments.size();
    }
}

