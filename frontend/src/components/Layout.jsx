import React from "react";
import styled from 'styled-components'

const Layout = (props) => {
    return (
        <StLayout>
            <StHeader />
            {props.children}
            <StFooter />
        </StLayout>
    )
}

export default Layout

const StLayout = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
`


const StHeader = styled.div`
    width: 100%;
    height: 50px;
`

const StFooter = styled.div`
    width: 100%;
    height: 50px;
`;