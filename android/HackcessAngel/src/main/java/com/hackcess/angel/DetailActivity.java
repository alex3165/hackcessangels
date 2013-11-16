package com.hackcess.angel;

import android.app.Activity;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBar;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.os.Build;
import android.widget.TextView;

public class DetailActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        TextView textViewHandicap = (TextView) findViewById(R.id.textViewHandicap);
        HandicapType message=HandicapType.PHYSICAL;
        switch(message)  {
            case PHYSICAL :
                textViewHandicap.setText("Handicape physique");
                break;
            case MENTAL :
                textViewHandicap.setText("handicape mental");
                break;
            case DEAF :
                textViewHandicap.setText("Je suis sourd.");
                break;

            case PRAGNENT :
                textViewHandicap.setText("Je suis enceinte");
                break;

            case LUGGAGE :
                textViewHandicap.setText("J'ai des baggages lourds.");
                break;


        }
    }

    public enum HandicapType{
        PHYSICAL, MENTAL, DEAF, PRAGNENT, LUGGAGE

    }

}
