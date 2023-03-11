import React from 'react';
import styled from 'styled-components';

const MainTable = ({ data }) => {
    console.log(data)

    return (
        <div>
            <StTable>
                <thead>
                    <tr>
                        <StTh>제목</StTh>
                        <StTh>작성자</StTh>
                        <StTh>작성 시간</StTh>
                    </tr>
                </thead>
                <tbody>
                    {data.map((item) => {
                        return (
                            <tr
                                key={item.id}
                            >
                                <StTd>{item.title}</StTd>
                                <StTd>{item.id}</StTd>
                                <StTd>{item.created_at}</StTd>
                            </tr>
                        );
                    })}

                </tbody>
            </StTable>
        </div >
    );
};

export default MainTable;


const StTable = styled.table`
    border-collapse: collapse;
    margin: 20px 0;
    text-align: center;
    border-radius: 24px;
    box-shadow: rgba(0, 0, 0, 0.2) 0 3px 5px -1px,
    rgba(0, 0, 0, 0.14) 0 6px 10px 0, rgba(0, 0, 0, 0.12) 0 1px 18px 0;
    overflow: hidden;
`;

const StTh = styled.th`
    border-bottom: 1px solid #ddd;
    background-color: #ffbc3f;
    font-weight: bold;
    padding: 1rem;
    color: white;

    &:first-child {
    width: 400px;
    }
    &:nth-child(2) {
    width: 100px;
    }
    &:last-child {
    width: 120px;
    }
`;

const StTd = styled.td`
    border-top: 1px solid #ddd;
    padding: 1rem 2rem;

    &:first-child {
    text-align: left;
    }
`;