package com.hackcess.angel;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.support.v4.app.Fragment;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageButton;
import android.widget.TextView;

public class DetailActivity extends Fragment {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.activity_detail, container, false);

        /*TextView textViewHandicap = (TextView) rootView.findViewById(R.id.textViewHandicap);
        HandicapType message=HandicapType.PHYSICAL;
        switch(message)  {
            case PHYSICAL :
                textViewHandicap.setText("Handicap physique");
                break;
            case MENTAL :
                textViewHandicap.setText("Handicap mental");
                break;
            case DEAF :
                textViewHandicap.setText("Je suis sourd.");
                break;

            case PREGNANT:
                textViewHandicap.setText("Je suis enceinte");
                break;

            case LUGGAGE :
                textViewHandicap.setText("J'ai des baggages lourds.");
                break;
        }*/

        //ImageButton submit=(ImageButton) rootView.findViewById(R.id.imageButton);
        return rootView;
    }

    public void onActivityResult(int requestCode, int resultCode,
                                    Intent data) {
        android.util.Log.d("TEST", "truc");
    }

    public void onStart() {
        super.onStart();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    public enum HandicapType{
        PHYSICAL, MENTAL, DEAF, PREGNANT, LUGGAGE

    }

    public class MyTextView extends TextView {

        public MyTextView(Context context, AttributeSet attrs, int defStyle) {
            super(context, attrs, defStyle);
            init();
        }

        public MyTextView(Context context, AttributeSet attrs) {
            super(context, attrs);
            init();
        }

        public MyTextView(Context context) {
            super(context);
            init();
        }

        public void init() {
            Typeface tf = Typeface.createFromAsset(getContext().getAssets(), "Lato-Lig.ttf");
            setTypeface(tf ,1);

        }

    }

}



