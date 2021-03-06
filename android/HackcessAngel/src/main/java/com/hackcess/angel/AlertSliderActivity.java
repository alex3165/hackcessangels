package com.hackcess.angel;
import java.util.List;
import java.util.Vector;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.view.Menu;

import com.hackcess.angel.verticalviewpager.PagerAdapter;
import com.hackcess.angel.verticalviewpager.VerticalViewPager;

public class AlertSliderActivity extends FragmentActivity {

    private PagerAdapter mPagerAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        super.setContentView(R.layout.alert_viewpager);

        // Création de la liste de Fragments que fera défiler le PagerAdapter
        List fragments = new Vector();

        Intent intent = getIntent();
        if (intent.hasExtra("requestCode")) {
            int message_type = intent.getExtras().getInt("requestCode");

            // Ajout des Fragments dans la liste
            fragments.add(Fragment.instantiate(this, DetailActivity.class.getName()));
        } else {
            fragments.add(Fragment.instantiate(this, DetailActivity.class.getName()));
        }
        fragments.add(Fragment.instantiate(this, DetailMap.class.getName()));

        // Création de l'adapter qui s'occupera de l'affichage de la liste de
        // Fragments
        this.mPagerAdapter = new AlertPagerAdapter(super.getSupportFragmentManager(), fragments);

        VerticalViewPager pager = (VerticalViewPager) super.findViewById(R.id.alert_viewpager);
        // Affectation de l'adapter au ViewPager
        pager.setAdapter(this.mPagerAdapter);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }


}
