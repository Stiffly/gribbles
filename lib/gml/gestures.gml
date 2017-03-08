<Gesture id="n-drag" type="drag">
    <match>
        <action>
            <initial>
                <cluster point_number="0" point_number_min="1" point_number_max="10"/>
            </initial>
        </action>
    </match>       
    <analysis>
        <algorithm class="kinemetric" type="continuous">
            <library module="drag"/>
            <returns>
                <property id="drag_dx" result="dx"/>
                <property id="drag_dy" result="dy"/>
            </returns>
        </algorithm>
    </analysis>    
    <mapping>
        <update dispatch_type="continuous">
            <gesture_event type="drag">
                <property ref="drag_dx" target="x"/>
                <property ref="drag_dy" target="y"/>
            </gesture_event>
        </update>
    </mapping>
</Gesture>